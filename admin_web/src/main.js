import './style.css'
import { auth, db } from './firebase.js'
import { signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut } from "firebase/auth";
import { collection, addDoc, getDocs, updateDoc, query, where, orderBy, serverTimestamp, collectionGroup } from "firebase/firestore";

// UI Elements
const authScreen = document.getElementById('auth-screen');
const dashboardScreen = document.getElementById('dashboard-screen');
const authForm = document.getElementById('auth-form');
const authToggleBtn = document.getElementById('auth-toggle-btn');
const authModeText = document.getElementById('auth-mode-text');
const authSubmitBtn = document.getElementById('auth-submit');
const authError = document.getElementById('auth-error');
const userEmailText = document.getElementById('user-email');
const logoutBtn = document.getElementById('logout-btn');

const navBtns = document.querySelectorAll('.nav-btn');
const tabContents = document.querySelectorAll('.tab-content');

const addCenterBtn = document.getElementById('add-center-btn');
const addCenterModal = document.getElementById('add-center-modal');
const closeModalBtn = document.getElementById('close-modal-btn');
const cancelModalBtn = document.getElementById('cancel-modal-btn');
const addCenterForm = document.getElementById('add-center-form');
const modalError = document.getElementById('modal-error');
const centersGrid = document.getElementById('centers-grid');
const bookingsList = document.getElementById('bookings-list');

let isLoginMode = true;
let currentUser = null;

// =======================
// AUTHENTICATION LOGIC
// =======================

onAuthStateChanged(auth, (user) => {
  if (user) {
    currentUser = user;
    userEmailText.textContent = user.email;
    showDashboard();
    loadCenters();
    loadBookings();
  } else {
    currentUser = null;
    showAuth();
  }
});

authToggleBtn.addEventListener('click', () => {
  isLoginMode = !isLoginMode;
  authModeText.textContent = isLoginMode ? "Don't have an account?" : "Already have an account?";
  authToggleBtn.textContent = isLoginMode ? "Sign Up" : "Sign In";
  authSubmitBtn.textContent = isLoginMode ? "Sign In" : "Sign Up";
  authError.classList.add('hidden');
});

authForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  const email = document.getElementById('auth-email').value;
  const password = document.getElementById('auth-password').value;

  authSubmitBtn.disabled = true;
  authSubmitBtn.textContent = 'Please wait...';
  authError.classList.add('hidden');

  try {
    if (isLoginMode) {
      await signInWithEmailAndPassword(auth, email, password);
    } else {
      await createUserWithEmailAndPassword(auth, email, password);
      // Wait, let's keep it simple. Any user who signs up here is considered an Admin for their Centers.
    }
  } catch (err) {
    authError.textContent = err.message;
    authError.classList.remove('hidden');
  } finally {
    authSubmitBtn.disabled = false;
    authSubmitBtn.textContent = isLoginMode ? "Sign In" : "Sign Up";
  }
});

logoutBtn.addEventListener('click', () => signOut(auth));


// =======================
// UI NAVIGATION
// =======================

function showAuth() {
  authScreen.classList.remove('hidden');
  dashboardScreen.classList.add('hidden');
}

function showDashboard() {
  authScreen.classList.add('hidden');
  dashboardScreen.classList.remove('hidden');
}

navBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    navBtns.forEach(b => b.classList.remove('active'));
    tabContents.forEach(t => t.classList.add('hidden'));

    btn.classList.add('active');
    document.getElementById(`tab-${btn.dataset.tab}`).classList.remove('hidden');
  });
});

// Modal Logic
addCenterBtn.addEventListener('click', () => addCenterModal.classList.remove('hidden'));
closeModalBtn.addEventListener('click', () => addCenterModal.classList.add('hidden'));
cancelModalBtn.addEventListener('click', () => addCenterModal.classList.add('hidden'));

const getLocationBtn = document.getElementById('get-location-btn');
getLocationBtn.addEventListener('click', () => {
  const originalText = getLocationBtn.innerHTML;
  getLocationBtn.innerHTML = '⏳ Loading...';

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        document.getElementById('center-lat').value = position.coords.latitude.toFixed(6);
        document.getElementById('center-lng').value = position.coords.longitude.toFixed(6);
        getLocationBtn.innerHTML = originalText;
      },
      (error) => {
        alert('Could not get location: ' + error.message);
        getLocationBtn.innerHTML = originalText;
      }
    );
  } else {
    alert('Geolocation is not supported by your browser');
    getLocationBtn.innerHTML = originalText;
  }
});


// =======================
// DATA LOGIC (FIRESTORE)
// =======================

async function loadCenters() {
  centersGrid.innerHTML = '<div class="loading-spinner"></div>';
  try {
    const q = query(collection(db, "centers"), where("adminId", "==", currentUser.uid));
    const querySnapshot = await getDocs(q);

    if (querySnapshot.empty) {
      centersGrid.innerHTML = '<p class="hint-text">No centers added yet.</p>';
      return;
    }

    centersGrid.innerHTML = '';
    querySnapshot.forEach((doc) => {
      const data = doc.data();
      const div = document.createElement('div');
      div.className = 'center-card';
      div.innerHTML = `
        <img src="${data.imageUrl}" alt="Center Photo" class="center-img" onerror="this.src='https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800'">
        <div class="center-info">
          <h3>${data.name}</h3>
          <p>📍 ${data.address}</p>
          <p>🕒 ${data.openTime} - ${data.closeTime}</p>
        </div>
      `;
      centersGrid.appendChild(div);
    });
  } catch (err) {
    console.error("Error loading centers:", err);
    centersGrid.innerHTML = '<p class="error-text">Failed to load centers.</p>';
  }
}

async function loadBookings() {
  bookingsList.innerHTML = '<div class="loading-spinner"></div>';
  try {
    // Note: This requires a composite index in Firestore if we sort, so we just filter by adminId on clientside if needed. 
    // Actually, currently bookings in Flutter app only have centerId. 
    // To filter bookings by admin, we need to get admin's centers first!

    const centersQ = query(collection(db, "centers"), where("adminId", "==", currentUser.uid));
    const centersSnap = await getDocs(centersQ);
    const centerIds = centersSnap.docs.map(d => d.id);

    if (centerIds.length === 0) {
      bookingsList.innerHTML = '<p class="hint-text">No bookings found because you have no centers.</p>';
      return;
    }

    // Firestore 'in' query supports up to 10 ids
    const maxIds = centerIds.slice(0, 10);
    const bookingsQ = query(collectionGroup(db, "bookings"), where("centerId", "in", maxIds));
    const bookingsSnap = await getDocs(bookingsQ);

    if (bookingsSnap.empty) {
      bookingsList.innerHTML = '<p class="hint-text">No bookings yet.</p>';
      return;
    }

    bookingsList.innerHTML = '';
    bookingsSnap.forEach((docSnap) => {
      const data = docSnap.data();
      // data.date might be a string (ISO) or Firestore Timestamp depending on Flutter upload
      const dateStr = data.date && data.date.toDate ? data.date.toDate().toLocaleDateString() : (data.date || 'Unknown Date');

      const div = document.createElement('div');
      div.className = 'booking-card';

      const statusLabel = data.status === 'completed'
        ? '<span style="color: #4ade80; font-size: 12px; font-weight: bold; border: 1px solid #4ade80; padding: 2px 6px; border-radius: 4px; margin-left: 8px;">Completed</span>'
        : '<span style="color: #fbbf24; font-size: 12px; font-weight: bold; border: 1px solid #fbbf24; padding: 2px 6px; border-radius: 4px; margin-left: 8px;">Pending</span>';

      div.innerHTML = `
        <div class="b-details" style="flex: 1;">
          <h4 style="display: flex; align-items: center;">${data.service} ${statusLabel}</h4>
          <p>🚗 ${data.centerName}</p>
          <p>📅 ${dateStr} at ${data.timeSlot}</p>
        </div>
        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
          <div class="b-price">₹${data.price}</div>
        </div>
      `;

      if (data.status !== 'completed' && data.status !== 'cancelled') {
        const btn = document.createElement('button');
        btn.className = 'btn primary-btn';
        btn.style.padding = '4px 12px';
        btn.style.fontSize = '12px';
        btn.innerText = 'Mark Completed';
        btn.onclick = async () => {
          btn.innerText = '...';
          btn.disabled = true;
          try {
            await updateDoc(docSnap.ref, { status: 'completed' });
            loadBookings(); // Reload to reflect changes
          } catch (e) {
            alert('Failed to update status: ' + e.message);
            btn.innerText = 'Mark Completed';
            btn.disabled = false;
          }
        };
        div.querySelector('div[style*="align-items: flex-end"]').appendChild(btn);
      }

      bookingsList.appendChild(div);
    });

  } catch (err) {
    console.error("Error loading bookings:", err);
    bookingsList.innerHTML = '<p class="error-text">Failed to load bookings. (May require index)</p>';
  }
}

// Generate TimeSlots array identically to how Flutter mock data does it
function generateTimeSlots(open, close) {
  // open: "08:00", close: "20:00"
  const slots = [];
  let [openHr, openMin] = open.split(':').map(Number);
  let [closeHr, closeMin] = close.split(':').map(Number);

  for (let h = openHr; h < closeHr; h++) {
    let period = h >= 12 ? 'PM' : 'AM';
    let displayH = h > 12 ? h - 12 : (h === 0 ? 12 : h);
    let displayM = openMin < 10 ? '0' + openMin : openMin;

    slots.push({
      id: 't' + h,
      time: `${displayH}:${displayM} ${period}`,
      isAvailable: true
    });
  }
  return slots;
}

function formatTimeAMPM(time24) {
  let [h, m] = time24.split(':').map(Number);
  let period = h >= 12 ? 'PM' : 'AM';
  let displayH = h > 12 ? h - 12 : (h === 0 ? 12 : h);
  let displayM = m < 10 ? '0' + m : m;
  return `${displayH}:${displayM} ${period}`;
}

addCenterForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  const btn = document.getElementById('save-center-btn');
  btn.disabled = true;
  btn.textContent = 'Saving...';
  modalError.classList.add('hidden');

  try {
    const name = document.getElementById('center-name').value;
    const imageUrl = document.getElementById('center-image').value;
    const description = document.getElementById('center-desc').value;
    const address = document.getElementById('center-address').value;
    const lat = parseFloat(document.getElementById('center-lat').value);
    const lng = parseFloat(document.getElementById('center-lng').value);
    const phone = document.getElementById('center-phone').value;
    const open24 = document.getElementById('center-open').value;
    const close24 = document.getElementById('center-close').value;

    const timeSlots = generateTimeSlots(open24, close24);

    // Standard services pack
    const defaultServices = [
      { name: "Basic Wash", duration: "30 min", price: 299, icon: "💧" },
      { name: "Premium Wash", duration: "45 min", price: 599, icon: "✨" },
      { name: "Interior Clean", duration: "60 min", price: 799, icon: "🧹" },
      { name: "Full Detail", duration: "90 min", price: 1499, icon: "💎" }
    ];

    const centerData = {
      adminId: currentUser.uid,
      name,
      imageUrl,
      description,
      address,
      latitude: lat,
      longitude: lng,
      phone,
      isOpen: true,
      openTime: formatTimeAMPM(open24),
      closeTime: formatTimeAMPM(close24),
      distance: 2.5, // Mock distance, app calculates real distance based on lat/lng anyway
      rating: 5.0,
      reviewCount: 0,
      services: defaultServices,
      timeSlots: timeSlots
    };

    await addDoc(collection(db, "centers"), centerData);

    addCenterModal.classList.add('hidden');
    addCenterForm.reset();
    loadCenters(); // reload list

  } catch (err) {
    console.error(err);
    modalError.textContent = err.message;
    modalError.classList.remove('hidden');
  } finally {
    btn.disabled = false;
    btn.textContent = 'Save Center';
  }
});
