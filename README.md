# LabLink – Backend

The backend service for **LabLink**, a full-stack diagnostic test comparison and appointment booking platform.

Built using Node.js, Express, TypeScript and PostgreSQL, the backend provides RESTful APIs for user authentication, diagnostic test discovery, laboratory-wise price comparison and appointment booking.

## Features

- **User Authentication:** User registration and login using JWT-based authentication.
- **Password Security:** Password hashing using bcrypt.
- **Diagnostic Test APIs:** Retrieve available diagnostic tests and their details.
- **Laboratory Management:** Retrieve partner laboratory information.
- **Price Comparison:** Fetch laboratory-wise prices and test availability.
- **Appointment Booking:** Create authenticated diagnostic test bookings.
- **Booking History:** Retrieve bookings associated with authenticated users.
- **Booking Cancellation:** Cancel existing bookings through authenticated API requests.
- **Database Integration:** Store and retrieve application data using PostgreSQL.

## Technology Stack

| Category | Technology |
|---|---|
| Runtime | Node.js |
| Backend Framework | Express.js |
| Programming Language | TypeScript |
| Database | PostgreSQL |
| Authentication | JSON Web Tokens (JWT) |
| Password Hashing | bcrypt |
| API Architecture | REST |
| Package Manager | npm |

## Project Structure

```text
lablink-backend/
│
├── src/
│   ├── routes/
│   ├── controllers/
│   ├── middleware/
│   ├── config/
│   └── app.ts
│
├── database/
│   └── SQL initialization and seed files
│
├── .env.example
├── .gitignore
├── package.json
├── package-lock.json
└── tsconfig.json
```

*Note: The directory structure above is illustrative. Adjust it to match the actual project files.*

## Requirements

Before running the backend, make sure you have:

- Node.js 20 or newer
- npm
- PostgreSQL
- Git (optional)

## Installation and Setup

### 1. Clone the Repository

```bash
git clone YOUR_BACKEND_REPOSITORY_URL
```

Navigate to the project directory:

```bash
cd lablink-backend
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Configure Environment Variables

Create a `.env` file in the project root.

Add the required configuration:

```env
PORT=5001
DATABASE_URL=your_postgresql_connection_string
JWT_SECRET=your_secure_random_secret
```

Use the actual environment variable names expected by your backend code. If your project uses separate PostgreSQL variables such as `DB_HOST`, `DB_USER` and `DB_PASSWORD`, configure those instead.

**Security:** Never commit your `.env` file, database passwords or JWT secrets to GitHub. Use `.env.example` with placeholder values for documentation.

### 4. Configure PostgreSQL

- Create the LabLink PostgreSQL database.
- Configure the database connection in `.env`.
- Execute the SQL initialization scripts.
- Execute the seed scripts to populate demonstration data.

The current demonstration dataset contains six sample diagnostic tests and six sample partner laboratories.

### 5. Start the Development Server

Run:

```bash
npm run dev
```

The backend is configured to run on:

```text
http://localhost:5001
```

The API base URL is:

```text
http://localhost:5001/api
```

Health check endpoint:

```text
http://localhost:5001/api/health
```

## API Functionality

The backend provides API functionality for the following operations:

| Module | Functionality |
|---|---|
| Authentication | Registration and login |
| Diagnostic Tests | Test listing, searching and details |
| Laboratories | Laboratory information |
| Price Comparison | Lab-wise test prices and availability |
| Bookings | Create diagnostic test bookings |
| Booking History | Retrieve user bookings |
| Booking Management | Cancel existing bookings |

Authenticated endpoints use JWT-based authorization.

## Running the Full Application

LabLink consists of two independently running applications.

**Backend terminal:**

```bash
npm run dev
```

**Frontend terminal:**

```bash
npm run dev
```

The frontend communicates with the backend through:

```text
http://localhost:5001/api
```

The frontend development server normally runs at:

```text
http://localhost:5173
```

## Database Design

PostgreSQL is used as the primary relational database.

The database manages interconnected application entities, including:

- Users
- Diagnostic laboratories
- Diagnostic tests
- Laboratory-specific test prices
- Appointment bookings

Relational constraints and database relationships help maintain data consistency across the application.

## Security Considerations

- Passwords are hashed using bcrypt.
- JWT authentication protects authorized operations.
- Sensitive configuration is stored in environment variables.
- Environment files containing secrets are excluded from version control.
- Backend CORS configuration restricts permitted frontend origins.

## Future Improvements

Potential enhancements include:

- Online payment integration.
- Email and SMS appointment notifications.
- Advanced laboratory search and filtering.
- Real-time appointment slot management.
- Laboratory administration dashboard.
- Improved error handling and automated testing.

## Project Information

**Project:** LabLink  
**Type:** Full-Stack Web Application  
**Backend:** Node.js + Express.js + TypeScript  
**Database:** PostgreSQL  
**Frontend:** React + TypeScript + Vite

LabLink demonstrates practical implementation of REST APIs, authentication, relational database management, backend development and full-stack application integration.
