import { app } from './app.js';
import { env } from './config/env.js';
import { pool } from './db/pool.js';

async function start() {
  try {
    await pool.query('SELECT 1');
    app.listen(env.PORT, () => {
      console.log(`LabLink API running at http://localhost:${env.PORT}`);
    });
  } catch (error) {
    console.error('Could not connect to PostgreSQL. Check DATABASE_URL and ensure PostgreSQL is running.', error);
    process.exit(1);
  }
}

void start();
