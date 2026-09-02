import { Pool } from "pg";

const connectionString = process.env.DATABASE_URL;
export const db = connectionString ? new Pool({ connectionString, ssl: process.env.NODE_ENV === "production" ? { rejectUnauthorized: false } : undefined }) : null;

export async function assertDatabase() {
  if (!db) throw new Error("DATABASE_URL is not configured. Copy .env.example to .env and configure PostgreSQL.");
  await db.query("SELECT 1");
  return db;
}
