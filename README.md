# LabLink Backend

The REST API for **LabLink**, a full-stack diagnostic test comparison and appointment booking platform.

Built with Node.js, Express, TypeScript, and PostgreSQL. The backend supports account authentication, diagnostic test and laboratory data, lab-wise price comparison, appointment booking, and AI-assisted medical report summaries.

**Live API:** https://lablink-backend-cp9v.onrender.com/api  
**Health check:** https://lablink-backend-cp9v.onrender.com/api/health

> **Demo-data notice:** Seeded laboratory listings, prices, and availability are sample data for demonstrating the application. They are not live quotes or verified listings from real diagnostic providers.

## Features

- **Authentication:** Registration and login with JWT-based authentication.
- **Password protection:** Passwords are hashed using bcrypt.
- **Diagnostic catalogue:** API support for listing and retrieving diagnostic tests.
- **Laboratories and price comparison:** Laboratory information, lab-specific test prices, and availability.
- **Appointment booking:** Authenticated users can create bookings with test, laboratory, collection type, date, time slot, and patient details.
- **Booking history:** Retrieve bookings for the authenticated user.
- **Booking cancellation:** Authenticated booking cancellation.
- **AI report summaries:** Authenticated report-upload endpoint that accepts PDF, JPEG, and PNG files, requires explicit consent, and sends the report for summarization using Google Gemini.
- **Upload validation:** In-memory upload handling, supported MIME-type validation, and a 10 MB file-size limit for report uploads.
- **API protection:** CORS configuration, Helmet security headers, and rate limiting.

## Technology Stack

| Category | Technology |
|---|---|
| Runtime | Node.js |
| Framework | Express.js |
| Language | TypeScript |
| Database | PostgreSQL |
| Authentication | JSON Web Tokens |
| Password hashing | bcryptjs |
| AI integration | Google Gemini API |
| Validation | Zod |
| Security middleware | Helmet, express-rate-limit |
| File uploads | Multer |
| PostgreSQL client | node-postgres (`pg`) |

## Repository

- **Backend:** https://github.com/akshaysachdeva2/lablink-backend-
- **Frontend:** https://github.com/akshaysachdeva2/lablink-frontend

## Requirements

- Node.js 20 or newer
- npm
- PostgreSQL

## Local Setup

### 1. Clone the repository

```bash
git clone https://github.com/akshaysachdeva2/lablink-backend-.git
cd lablink-backend-
npm install
```

### 2. Create the database

Create a PostgreSQL database named `lablink` (or update the connection string to match your database):

```sql
CREATE DATABASE lablink;
```

### 3. Configure environment variables

Create a `.env` file in the backend project root:

```env
PORT=5001
NODE_ENV=development
FRONTEND_URL=http://localhost:5173
DATABASE_URL=postgresql://USER:PASSWORD@HOST:5432/lablink
JWT_SECRET=replace_with_a_random_secret_of_at_least_32_characters
JWT_EXPIRES_IN=7d
GEMINI_API_KEY=your_gemini_api_key
```

Replace the placeholders with your own local PostgreSQL connection details and credentials. `GEMINI_API_KEY` is optional for starting the API, but is required to use the Gemini-powered functionality. Never commit your real `.env` file, database password, JWT secret, or API key.

### 4. Initialize and seed the database

The package scripts use the local PostgreSQL command-line client and the database name `lablink`:

```bash
npm run db:setup
npm run db:seed
```

If your PostgreSQL setup uses a different database user or connection configuration, adjust the commands/scripts for your environment before running them.

The current seed data contains 10 diagnostic tests, 20 laboratories, and approximately 200 lab-price records. These are demonstration records, not live provider data.

### 5. Start the development server

```bash
npm run dev
```

The configured local API port defaults to `5000`; if you use port `5001`, set `PORT=5001` in `.env`.

- API base: `http://localhost:5001/api` (when configured with port 5001)
- Health check: `http://localhost:5001/api/health`

## Available Scripts

| Command | Purpose |
|---|---|
| `npm install` | Install dependencies |
| `npm run dev` | Run the API in watch mode |
| `npm run build` | Compile TypeScript into `dist` |
| `npm start` | Run the compiled server |
| `npm run db:setup` | Apply `database/schema.sql` to the `lablink` database |
| `npm run db:seed` | Load `database/seed.sql` into the `lablink` database |

## API Capabilities

| Area | Capability |
|---|---|
| Authentication | Register and sign in |
| Diagnostic tests | Browse and retrieve test information |
| Laboratories | Retrieve laboratory information |
| Price comparison | Retrieve lab-wise prices and availability |
| Bookings | Create bookings for authenticated users |
| Booking history | Retrieve the signed-in user's bookings |
| Booking management | Cancel an existing booking |
| AI report summary | Upload a report with consent and request an AI-generated summary |

The report-summary endpoint expects an authenticated request with a multipart file field named `report` and a consent field set to `consent=true`. Supported uploads are PDF, JPEG, and PNG, up to 10 MB.

## Running with the Frontend

Run the backend and frontend in separate terminals. Start the frontend using its own README instructions and configure its `VITE_API_BASE_URL` to point to this API.

For local development, the frontend normally runs at `http://localhost:5173` and the backend API can run at `http://localhost:5001/api` when `PORT=5001` is configured. Set `FRONTEND_URL` to the frontend origin so the backend CORS configuration can allow it.

## Security and Medical Disclaimer

- Passwords are hashed; protected routes use JWT authentication.
- Configure secrets through environment variables and keep them out of source control.
- CORS is restricted to configured frontend origins and local development.
- Helmet and rate limiting are used as API security middleware.
- Report uploads require authentication and user consent and are subject to file-type and size checks.
- AI-generated report summaries are informational only, may be inaccurate, and are not a diagnosis or a substitute for a qualified medical professional.

## Project Overview

LabLink's backend demonstrates REST API development, authentication, relational database integration, booking workflows, upload validation, security middleware, and integration with an external generative AI service.
