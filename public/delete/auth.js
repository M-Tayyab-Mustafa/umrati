import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.0/firebase-app.js";
import {
  getFirestore,
  doc,
  deleteDoc,
} from "https://www.gstatic.com/firebasejs/10.12.0/firebase-firestore.js";
import {
  getAuth,
  RecaptchaVerifier,
  signInWithEmailAndPassword,
  signInWithPhoneNumber,
} from "https://www.gstatic.com/firebasejs/10.12.0/firebase-auth.js";

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDqS3fL514D4mdjZliV8hkBiGz7DU29b0o",
  authDomain: "umrati-ec453.firebaseapp.com",
  projectId: "umrati-ec453",
  storageBucket: "umrati-ec453.appspot.com",
  messagingSenderId: "422094310480",
  appId: "1:422094310480:web:bc13cad617c3dca104d555",
  measurementId: "G-0GGBY5MZRG",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app); // if 'app' is your initialized Firebase app

const emailTabBtn = document.getElementById("emailTabBtn");
const phoneTabBtn = document.getElementById("phoneTabBtn");
const verifyPhoneBtn = document.getElementById("verifyPhoneBtn");
const deleteBtn = document.getElementById("deleteBtn");
const emailInput = document.getElementById("email");
const emailError = document.getElementById("emailError");
const phoneInput = document.getElementById("phoneNumber");
const phoneError = document.getElementById("phoneError");
const passwordInput = document.getElementById("password");
const passwordError = document.getElementById("passwordError");
const verificationCode = document.getElementById("verificationCode");
const confirmSection = document.getElementById("confirmSection");

let currentTab = "email";

emailTabBtn.addEventListener("click", () => {
  switchTab("email");
});
phoneTabBtn.addEventListener("click", () => {
  switchTab("phone");
});

function switchTab(tab) {
  if (tab === currentTab) return;
  currentTab = tab;
  emailTabBtn.classList.toggle("active", tab === "email");
  phoneTabBtn.classList.toggle("active", tab === "phone");
  emailAuthForm.classList.toggle("hidden", tab !== "email");
  phoneAuthForm.classList.toggle("hidden", tab !== "phone");
  if (currentTab == "phone") {
    confirmSection.classList.add("hidden");
  } else {
    confirmSection.classList.remove("hidden");
  }
}

function validateEmail() {
  const email = emailInput.value.trim();
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (!email) {
    emailError.textContent = "Email is required.";
    return false;
  } else if (!emailPattern.test(email)) {
    emailError.textContent = "Please enter a valid email address.";
    return false;
  } else {
    emailError.textContent = "";
    return true;
  }
}

function validatePassword() {
  const password = passwordInput.value;

  if (!password) {
    passwordError.textContent = "Password is required.";
    return false;
  } else if (password.length < 6) {
    passwordError.textContent = "Password must be at least 6 characters.";
    return false;
  } else {
    passwordError.textContent = "";
    return true;
  }
}

function validatePhone() {
  const phone = phoneInput.value.trim();
  const phonePattern = /^\+\d{10,15}$/;

  if (!phone) {
    phoneError.textContent = "Phone number is required.";
    return false;
  } else if (!phonePattern.test(phone)) {
    phoneError.textContent =
      "Please enter a valid phone number (e.g. +923001234567).";
    return false;
  } else {
    phoneError.textContent = ""; // clear error if valid
    return true;
  }
}

verifyPhoneBtn.addEventListener("click", async () => {
  if (!validatePhone()) return;
  verifyPhoneBtn.disabled = true;
  verifyPhoneBtn.textContent = "Resend Code";
  let dynamicContainer = document.createElement("div");
  dynamicContainer.id = "dynamic-recaptcha-" + Date.now(); // Unique ID
  document.body.appendChild(dynamicContainer);
  let recaptchaVerifier = new RecaptchaVerifier(auth, dynamicContainer.id, {
    size: "invisible",
    callback: (response) => {
      verifyPhoneBtn.disabled = false;
      console.log("reCAPTCHA solved" + response);
    },
    "expired-callback": () => {
      console.warn("reCAPTCHA expired");
    },
  });
  try {
    window.confirmationResult = await signInWithPhoneNumber(
      auth,
      phoneInput.value.trim(),
      recaptchaVerifier
    );
    confirmSection.classList.remove("hidden");
    showToast("Verification code sent to your phone", "success");
  } catch (error) {
    verifyPhoneBtn.disabled = false;
    showToast(error, "error");
  }
});

deleteBtn.addEventListener("click", () => {
  if (currentTab == "email") {
    deleteAccountUsingEmail();
  } else {
    deleteAccountUsingPhone();
  }
});

async function deleteAccountUsingEmail() {
  if (!validateEmail()) return;
  if (!validatePassword()) return;
  deleteBtn.disabled = true;
  const email = emailInput?.value.trim();
  const password = passwordInput?.value;
  try {
    const userCredential = await signInWithEmailAndPassword(
      auth,
      email,
      password
    );
    const user = userCredential.user;
    await deleteDoc(doc(db, "users", user.uid));
    await user.delete();
    confirm("Your account has been successfully deleted.");
    window.close();
  } catch (error) {
    deleteBtn.disabled = false;
    verifyPhoneBtn.disabled = false;
    console.error("Code verification failed:", error);
  }
}

function deleteAccountUsingPhone() {
  verifyPhoneBtn.disabled = true;
  deleteBtn.disabled = true;
  const code = verificationCode.value.trim();
  window.confirmationResult
    .confirm(code)
    .then(async (result) => {
      const user = result.user;
      await deleteDoc(doc(db, "users", user.uid));
      await user.delete();
      confirm("Your account has been successfully deleted.");
      window.close();
    })
    .catch((error) => {
      deleteBtn.disabled = false;
      verifyPhoneBtn.disabled = false;
      console.error("Code verification failed:", error);
    });
}

// Toast notification function
function showToast(message, type = "success") {
  const toast = document.getElementById("toast");
  const toastMessage = document.getElementById("toast-message");
  const icon = toast.querySelector("i");

  toastMessage.textContent = message;

  if (type === "error") {
    toast.classList.add("error");
    icon.className = "fas fa-exclamation-circle";
  } else if (type === "success") {
    toast.classList.add("success");
    icon.className = "fas fa-check-circle";
  } else {
    toast.classList.remove("error", "success");
    icon.className = "fas fa-info-circle";
  }
  toast.classList.add("show");

  setTimeout(() => {
    toast.classList.remove("show");
  }, 3000);
}
