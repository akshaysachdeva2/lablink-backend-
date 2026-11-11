# LabLink Backend

Backend API for the LabLink diagnostic test comparison and booking frontend.

## Stack
- Node.js + Express
- TypeScript
- PostgreSQL (`pg`)
- JWT authentication + bcrypt password hashing
- Zod request validation

## 1. Requirements
- Node.js 20+
- PostgreSQL 15+ (local installation is fine)

## 2. Create the database
Open `psql` or pgAdmin and run:

```sql
CREATE DATABASE lablink;
```

Then from this backend folder, run the schema and demo data scripts. If your local PostgreSQL user is not `postgres`, adjust the `-U postgres` part:

```bash
psql -U postgres -d lablink -f database/schema.sql
psql -U postgres -d lablink -f database/seed.sql
```

The seeded lab names, ratings, addresses, and prices are fictional demo data. Replace them before launch.

## 3. Configure environment
Copy `.env.example` to `.env`, then set your actual local PostgreSQL password and a long random JWT secret:

```bash
cp .env.example .env
```

Example connection string:
`postgresql://postgres:YOUR_PASSWORD@localhost:5432/lablink`

Do not commit `.env`.

## 4. Install and run

```bash
npm install
npm run dev
```

Health check: `http://localhost:5000/api/health`

Production build:

```bash
npm run build
npm start
```

## API overview

| Method | Endpoint | Auth | Purpose |
|---|---|---:|---|
| GET | `/api/health` | No | API health |
| POST | `/api/auth/register` | No | Create account |
| POST | `/api/auth/login` | No | Login |
| GET | `/api/auth/me` | Yes | Current user |
| GET | `/api/tests` | No | Search/list tests |
| GET | `/api/tests/:slug` | No | Test details |
| GET | `/api/tests/:slug/labs` | No | Compare labs and prices |
| GET | `/api/labs` | No | List labs |
| POST | `/api/bookings` | Yes | Create booking |
| GET | `/api/bookings` | Yes | User's bookings |
| PATCH | `/api/bookings/:id/cancel` | Yes | Cancel a confirmed booking |

For protected endpoints, send:
`Authorization: Bearer <token>`

### Example registration body

```json
{
  "name": "Test User",
  "email": "test@example.com",
  "phone": "9876543210",
  "password": "StrongPass123"
}
```

### Example booking body

```json
{
  "labId": "UUID-FROM-GET-TEST-LABS",
  "testId": "UUID-FROM-GET-TEST",
  "collectionType": "home",
  "bookingDate": "2026-11-05",
  "timeSlot": "08:00 AM - 09:00 AM",
  "patientName": "Test User",
  "patientPhone": "9876543210",
  "address": "Your collection address"
}
```

## Notes
- Booking creation takes the price from the database; the client cannot choose the amount.
- Users can only view/cancel their own bookings.
- This is a development foundation, not production-ready healthcare infrastructure. Before launch add email/phone verification, password reset, audit logging, stronger operational monitoring, real lab integrations, payment processing, and privacy/security review.
- Do not store medical reports or sensitive clinical records in this starter API.
