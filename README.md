# 📱 Topografía App

Aplicación móvil desarrollada en **Flutter** que permite a **topógrafos** registrar y enviar su ubicación en tiempo real hacia una base de datos en la nube (**Supabase**).  
El sistema incluye autenticación de usuarios, manejo de roles (administrador/topógrafo), visualización de mapa y un servicio en segundo plano para enviar la ubicación aún cuando la aplicación esté cerrada.

---

## 👨‍💻 Integrantes

**Ariel Ashqui** - **Evelyn Guachamin** - **Jonathan Ramirez**

Estudiantes de Tecnología Superior en Desarrollo de Software  
Escuela Politécnica Nacional

---

- ## Apk dentro del link

https://epnecuador-my.sharepoint.com/:u:/g/personal/ariel_ashqui_epn_edu_ec/ESYt4Wfq-O5Cv8b63FLx3h8BGGV9vL2FubEyU2LsDT_3MA?e=VCp10I
 
---

- ## Administrador panel

https://administrador-topografia.vercel.app/

---

- ## Link del video



---

- ## Link de la tienda con la aplicacion

https://www.amazon.com/dp/B0FLD3NBQ4/ref=mp_s_a_1_1?crid=3PFGTKRKYP5VX&dib=eyJ2IjoiMSJ9.HLa6eB3e4XVqasuamU6mWvSSLitPMfLfq-bO2IUvqal9vH_Zponw7eBO0B4QBfUqXDSpuEbSN4ITZVRoEI9X40rbQTGpNBcTQMinxnpYtrClABFkSPKO6YgoT9ewCWBI5LSlVNYAi9JikQnKpINbJMsKP_DW2utBHyAzUBE0SDLqkANwbs6-6hqgfRNxT83ZARRKfNAKrSaq0DW_MSa2jw.1QRnxIQriqtqdkdE8ht_9g8gaWGeNhxysC_Ctis2m2Y&dib_tag=se&keywords=GeoMap&qid=1754493290&sprefix=geomap%2Caps%2C183&sr=8-1

- ## Aplicacion firmada y publicada en la tienda de Amazon

<img width="1709" height="472" alt="image" src="https://github.com/user-attachments/assets/a8263f44-ef26-40bb-a5ce-2c785348e394" />

<img width="366" height="674" alt="image" src="https://github.com/user-attachments/assets/c878228d-964a-4547-bff1-0fe68d1a3e38" />  <img width="464" height="620" alt="image" src="https://github.com/user-attachments/assets/3811ff4a-9057-4204-a6a5-912a17274635" />

<img width="296" height="611" alt="image" src="https://github.com/user-attachments/assets/83901bf3-8b67-4f11-9aaa-91c47473075b" />

<img width="1623" height="345" alt="image" src="https://github.com/user-attachments/assets/b7dc91f7-a73b-463a-bfba-4f48f6ffaaab" />

---

## 🚀 Tecnologías utilizadas

- **Flutter**
- **Dart**
- **Supabase** (Base de datos y autenticación)
- **Geolocator** (para obtener la ubicación del dispositivo)
- **Workmanager** (para mantener el rastreo de ubicación en segundo plano)
- **Android SDK 33**

---

## 🗂️ Estructura del proyecto

- **main.dart** → Punto de entrada de la app  
- **location_callback_handler.dart** → Lógica para enviar ubicación a Supabase  
- **pages/**  
  - `auth_page.dart` → Pantalla de autenticación/login  
  - `home_page.dart` → Pantalla principal con control de roles  
  - `admin_page.dart` → Pantalla de administrador  
  - `map_page.dart` → Pantalla con el mapa para topógrafos  
- **services/**  
  - `auth_service.dart` → Manejo de autenticación

  <img width="344" height="605" alt="Captura de pantalla 2025-08-04 231928" src="https://github.com/user-attachments/assets/e4690439-1f94-4b74-b54e-12c260ba48d4" />

---

## ⚙️ Configuración del proyecto

1. Clonar el repositorio.  
2. Instalar dependencias con `flutter pub get`.  
3. Configurar Supabase con la URL y anonKey del proyecto.  
4. Crear en Supabase la tabla **usuarios** con campos: id, email, rol, lat, lng, last_update.  

<img width="1919" height="616" alt="image" src="https://github.com/user-attachments/assets/634435d5-6580-43de-a8b0-a7232b928b75" />

---

## 📍 Funcionamiento

- **Autenticación:** inicio de sesión con Supabase.

<img width="1819" height="640" alt="image" src="https://github.com/user-attachments/assets/33d92840-d080-40b4-b376-23b8f4e17908" />
  
<img width="1917" height="875" alt="image" src="https://github.com/user-attachments/assets/009c9aa8-f5b8-4b4d-8f03-ebca99117296" />

- **Roles:**  
  - Administrador → `AdminPage`.  
  - Topógrafo → `MapPage`.  
- **Ubicación en tiempo real:**  
  - Se obtiene cada 10 segundos.  
  - Se guarda en Supabase con fecha/hora.
    
  <img width="1918" height="535" alt="image" src="https://github.com/user-attachments/assets/8b2a3d0e-826b-465d-8c7c-385e398ffbee" />
  
  - Funciona en segundo plano gracias al servicio persistente.
 
    <img width="746" height="366" alt="image" src="https://github.com/user-attachments/assets/38b714a1-eea3-4cb4-9e2f-39377d202a5a" />

    
- **Servicio en background:** inicia al loguearse y se mantiene activo con notificación en Android.

<img width="504" height="376" alt="image" src="https://github.com/user-attachments/assets/05067738-93f3-4034-a666-ab5043bf0850" />

---

## 🖼️ Capturas

- Pantalla de login.
  
<img width="1919" height="989" alt="image" src="https://github.com/user-attachments/assets/b47e1363-0860-4f20-a3e6-fd9e31faeba3" />

- Mapa con ubicación del topógrafo.

<img width="1919" height="887" alt="image" src="https://github.com/user-attachments/assets/7f6aaf9f-6cb3-4582-80e8-a883e6a1f37b" />

- Registrar terreno

<img width="1919" height="1050" alt="image" src="https://github.com/user-attachments/assets/4920ffdb-2b64-40c5-9265-b61ec9ae4dac" />

- Vista de administrador.
  
<img width="1919" height="1065" alt="image" src="https://github.com/user-attachments/assets/2560a22e-94d8-4475-aa8a-4571b8fdc6bf" />

<img width="1872" height="974" alt="image" src="https://github.com/user-attachments/assets/b0a3fa4d-cbec-4e2e-908e-7db2209a23e6" />

---

## 🧪 Pruebas realizadas

- ✅ Login correcto con Supabase.  
- ✅ Guardado de ubicación en la tabla `usuarios`.    
- ✅ Diferenciación de roles entre admin y topógrafo.

---

## 📌 Calculo del terreno 

- Se realizo el calculo con la formula del poligon de shoelace

<img width="1917" height="1041" alt="image" src="https://github.com/user-attachments/assets/f700e410-80b0-43d7-b9a5-5a73047a31d1" />

<img width="1919" height="973" alt="image" src="https://github.com/user-attachments/assets/9150dadf-ea36-4a60-86ea-29b9aea72b7a" />
