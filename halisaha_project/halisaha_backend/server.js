const express = require("express");
const cors = require("cors");
const fs = require("fs");
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

const USERS_FILE = "./users.json";
const FIELDS_FILE = "./fields.json";
const RESERVATIONS_FILE = "./reservations.json";

// 📂 USERS
function loadUsers() {
  try {
    const data = fs.readFileSync(USERS_FILE, "utf-8");
    return JSON.parse(data);
  } catch {
    return [];
  }
}
function saveUsers(users) {
  fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2));
}

// 📂 FIELDS
function loadFields() {
  try {
    const data = fs.readFileSync(FIELDS_FILE, "utf-8");
    return JSON.parse(data);
  } catch {
    return [];
  }
}
function saveFields(fields) {
  fs.writeFileSync(FIELDS_FILE, JSON.stringify(fields, null, 2));
}

// 📂 RESERVATIONS
function loadReservations() {
  try {
    const data = fs.readFileSync(RESERVATIONS_FILE, "utf-8");
    return JSON.parse(data);
  } catch {
    return [];
  }
}
function saveReservations(reservations) {
  fs.writeFileSync(RESERVATIONS_FILE, JSON.stringify(reservations, null, 2));
}

// 🧪 Test endpoint
app.get("/", (req, res) => {
  res.send("⚽ Halı Saha Backend Çalışıyor ✅");
});

// 🧍‍♂️ Kayıt ol
app.post("/register", (req, res) => {
  const { name, username, email, password, phone, city } = req.body;
  if (!name || !email || !password) {
    return res.status(400).json({ message: "Ad, e-posta ve şifre zorunludur!" });
  }

  const users = loadUsers();
  const existingUser = users.find(
    (u) => u.email === email || u.username === username || u.phone === phone
  );
  if (existingUser) {
    return res.status(400).json({ message: "Bu kullanıcı zaten kayıtlı!" });
  }

  const newUser = { id: Date.now(), name, username, email, password, phone, city };
  users.push(newUser);
  saveUsers(users);

  console.log("Yeni kullanıcı eklendi:", newUser);
  res.json({ message: "Kayıt başarılı ✅" });
});

// 🔑 Giriş yap
app.post("/login", (req, res) => {
  const { email, password } = req.body;
  const users = loadUsers();

  const user = users.find(
    (u) =>
      (u.email === email || u.username === email || u.phone === email) &&
      u.password === password
  );

  if (!user) {
    return res
      .status(401)
      .json({ message: "Bilgiler hatalı ❌ E-posta, kullanıcı adı veya telefon kontrol edin." });
  }

  res.json({ message: "Giriş başarılı ✅", user });
});

// 🔍 Kullanıcı bilgisi getir
app.get("/get-user/:id", (req, res) => {
  const userId = Number(req.params.id);
  const users = loadUsers();
  const user = users.find((u) => u.id === userId);
  if (!user) return res.status(404).json({ message: "Kullanıcı bulunamadı" });
  res.json(user);
});

// ✏️ Kullanıcı bilgilerini düzenle
app.put("/edit-user/:id", (req, res) => {
  const userId = Number(req.params.id);
  const { name, username, email, phone, city } = req.body;
  const users = loadUsers();
  const index = users.findIndex((u) => u.id === userId);
  if (index === -1) return res.status(404).json({ message: "Kullanıcı bulunamadı" });

  users[index] = { ...users[index], name, username, email, phone, city };
  saveUsers(users);

  console.log("Kullanıcı güncellendi:", users[index]);
  res.json({ message: "Profil başarıyla güncellendi ✅", user: users[index] });
});

// ⚽ İlk saha verilerini yükle (eğer fields.json yoksa)
if (!fs.existsSync(FIELDS_FILE)) {
  const defaultFields = [
  {
    id: 1,
    name: "Seka Futbol Tesisleri",
    location: "Kocaeli",
    price: 3000,
    capacity: "8 + 1",
    image: "seka.jpeg",
    availability: {
      Pazartesi: { "18:00": true, "19:00": false, "20:00": true, "21:00": true, "22:00": false, "23:00": true, "00:00": true, "01:00": true, "02:00": true },
      Salı: { "18:00": true, "19:00": false, "20:00": false, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": false },
      Çarşamba: { "18:00": false, "19:00": true, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
      Perşembe: { "18:00": true, "19:00": true, "20:00": true, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Cuma: { "18:00": false, "19:00": false, "20:00": true, "21:00": true, "22:00": false, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Cumartesi: { "18:00": true, "19:00": false, "20:00": true, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Pazar: { "18:00": true, "19:00": true, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
    },
  },
  {
    id: 2,
    name: "Tepebaşı Spor Tesisleri",
    location: "Eskişehir",
    price: 2500,
    capacity: "7 + 1",
    image: "tepebasi.jpeg",
    availability: {
      Pazartesi: { "18:00": true, "19:00": true, "20:00": false, "21:00": false, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Salı: { "18:00": true, "19:00": false, "20:00": true, "21:00": true, "22:00": false, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
      Çarşamba: { "18:00": false, "19:00": false, "20:00": true, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": false },
      Perşembe: { "18:00": true, "19:00": true, "20:00": true, "21:00": false, "22:00": false, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Cuma: { "18:00": false, "19:00": true, "20:00": true, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": false, "02:00": true },
      Cumartesi: { "18:00": true, "19:00": true, "20:00": false, "21:00": false, "22:00": true, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Pazar: { "18:00": true, "19:00": true, "20:00": true, "21:00": true, "22:00": false, "23:00": false, "00:00": true, "01:00": true, "02:00": false },
    },
  },
  {
    id: 3,
    name: "Şişli Field",
    location: "İstanbul",
    price: 4200,
    capacity: "10 + 1",
    image: "sislivip.jpg",
    availability: {
      Pazartesi: { "18:00": false, "19:00": false, "20:00": true, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": false, "02:00": true },
      Salı: { "18:00": true, "19:00": true, "20:00": false, "21:00": true, "22:00": true, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Çarşamba: { "18:00": true, "19:00": false, "20:00": true, "21:00": false, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": false },
      Perşembe: { "18:00": false, "19:00": true, "20:00": true, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Cuma: { "18:00": true, "19:00": false, "20:00": false, "21:00": true, "22:00": true, "23:00": true, "00:00": false, "01:00": true, "02:00": false },
      Cumartesi: { "18:00": false, "19:00": true, "20:00": true, "21:00": true, "22:00": false, "23:00": true, "00:00": true, "01:00": true, "02:00": true },
      Pazar: { "18:00": true, "19:00": true, "20:00": false, "21:00": true, "22:00": true, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
    },
  },
  {
    id: 4,
    name: "Karapürçek Halısaha",
    location: "Ankara",
    price: 2200,
    capacity: "7 + 1",
    image: "karapurcek.jpg",
    availability: {
      Pazartesi: { "18:00": true, "19:00": true, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
      Salı: { "18:00": true, "19:00": false, "20:00": false, "21:00": true, "22:00": true, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Çarşamba: { "18:00": true, "19:00": true, "20:00": true, "21:00": false, "22:00": false, "23:00": true, "00:00": true, "01:00": true, "02:00": false },
      Perşembe: { "18:00": false, "19:00": true, "20:00": true, "21:00": true, "22:00": true, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
      Cuma: { "18:00": false, "19:00": true, "20:00": true, "21:00": false, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Cumartesi: { "18:00": true, "19:00": false, "20:00": true, "21:00": true, "22:00": false, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Pazar: { "18:00": true, "19:00": false, "20:00": true, "21:00": true, "22:00": true, "23:00": true, "00:00": true, "01:00": true, "02:00": true },
    },
  },
  {
    id: 5,
    name: "Akev Halısaha",
    location: "Antalya",
    price: 3200,
    capacity: "8 + 1",
    image: "akev.jpeg",
    availability: {
      Pazartesi: { "18:00": true, "19:00": true, "20:00": false, "21:00": true, "22:00": true, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Salı: { "18:00": false, "19:00": false, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": true, "02:00": false },
      Çarşamba: { "18:00": true, "19:00": true, "20:00": true, "21:00": true, "22:00": false, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Perşembe: { "18:00": true, "19:00": true, "20:00": true, "21:00": false, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Cuma: { "18:00": false, "19:00": true, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
      Cumartesi: { "18:00": true, "19:00": false, "20:00": true, "21:00": true, "22:00": false, "23:00": true, "00:00": true, "01:00": true, "02:00": true },
      Pazar: { "18:00": true, "19:00": false, "20:00": false, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
    },
  },
  {
    id: 6,
    name: "ItasportX Halısaha",
    location: "Kocaeli",
    price: 3200,
    capacity: "7 + 1",
    image: "itasportx.jpg",
    availability: {
      Pazartesi: { "18:00": false, "19:00": true, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": true, "02:00": false },
      Salı: { "18:00": true, "19:00": true, "20:00": false, "21:00": false, "22:00": true, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Çarşamba: { "18:00": true, "19:00": false, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": false, "02:00": true },
      Perşembe: { "18:00": true, "19:00": true, "20:00": true, "21:00": false, "22:00": false, "23:00": true, "00:00": true, "01:00": true, "02:00": true },
      Cuma: { "18:00": false, "19:00": true, "20:00": false, "21:00": true, "22:00": true, "23:00": false, "00:00": true, "01:00": true, "02:00": true },
      Cumartesi: { "18:00": true, "19:00": true, "20:00": true, "21:00": false, "22:00": false, "23:00": true, "00:00": false, "01:00": true, "02:00": true },
      Pazar: { "18:00": true, "19:00": false, "20:00": true, "21:00": false, "22:00": true, "23:00": true, "00:00": true, "01:00": true, "02:00": false },
    },
  },
];

  saveFields(defaultFields);
}

// ⚽ Sahaları getir
app.get("/fields", (req, res) => {
  const fields = loadFields();
  res.json(fields);
});

// 🧾 Rezervasyon oluştur
app.post("/reserve", (req, res) => {
  const { userId, fieldId, day, time } = req.body;
  if (!userId || !fieldId || !day || !time) {
    return res.status(400).json({ message: "Eksik bilgi gönderildi!" });
  }

  const fields = loadFields();
  const reservations = loadReservations();

  const fieldIndex = fields.findIndex((f) => f.id === fieldId);
  if (fieldIndex === -1) {
    return res.status(404).json({ message: "Saha bulunamadı!" });
  }

  const slot = fields[fieldIndex].availability?.[day]?.[time];
  if (slot !== true) {
    return res.status(400).json({ message: "Bu saat zaten dolu ❌" });
  }

  fields[fieldIndex].availability[day][time] = false;
  saveFields(fields);

  const newRes = {
    id: Date.now(),
    userId,
    fieldId,
    day,
    time,
    status: "pending",
    createdAt: new Date().toISOString(),
  };
  reservations.push(newRes);
  saveReservations(reservations);

  console.log(`✅ Rezervasyon: user#${userId} -> field#${fieldId} ${day} ${time}`);
  res.json({ message: "Rezervasyon başarıyla oluşturuldu ✅", reservation: newRes });
});

// 🎯 Kullanıcının rezervasyonlarını getir
app.get("/reservations/:userId", (req, res) => {
  const userId = Number(req.params.userId);
  const reservations = loadReservations();
  const fields = loadFields();

  const mine = reservations
    .filter((r) => r.userId === userId)
    .map((r) => {
      const field = fields.find((f) => f.id === r.fieldId);
      return {
        ...r,
        fieldName: field?.name ?? "Bilinmeyen Saha",
        location: field?.location ?? "-",
        price: field?.price ?? 0,
        image: field?.image ?? null,
      };
    })
    .sort((a, b) => b.id - a.id);

  res.json(mine);
});

app.listen(PORT, () => {
  console.log(`✅ Sunucu ${PORT} portunda çalışıyor`);
});
