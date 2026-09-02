import cors from "cors";
import express from "express";
import { randomUUID } from "node:crypto";
import { z } from "zod";

const app = express();
app.use(cors());
app.use(express.json());

const statuses = ["RECEIVED", "INSPECTION", "ESTIMATE_SENT", "APPROVED", "WAITING_FOR_PARTS", "IN_PROGRESS", "QUALITY_CHECK", "READY", "DELIVERED", "CANCELLED"] as const;
const createJobSchema = z.object({
  customerName: z.string().trim().min(2), phone: z.string().trim().min(10),
  category: z.enum(["MOBILE", "ELECTRONICS"]), product: z.string().trim().min(2),
  brand: z.string().trim().optional(), model: z.string().trim().optional(), imei1: z.string().trim().optional(),
  imei2: z.string().trim().optional(), quantity: z.number().int().positive().default(1),
  complaint: z.string().trim().min(3), estimatedAmount: z.number().nonnegative().optional()
});
type Job = z.infer<typeof createJobSchema> & { id: string; ticketNo: string; status: typeof statuses[number]; createdAt: string };
const jobs: Job[] = [];

app.get("/health", (_req, res) => res.json({ ok: true, service: "FixMitra API" }));
app.get("/api/repair-jobs", (_req, res) => res.json(jobs));
app.post("/api/repair-jobs", (req, res) => {
  const result = createJobSchema.safeParse(req.body);
  if (!result.success) return res.status(400).json({ message: "Please enter all required repair details.", errors: result.error.flatten() });
  const job: Job = { ...result.data, id: randomUUID(), ticketNo: `FM-${String(jobs.length + 1).padStart(6, "0")}`, status: "RECEIVED", createdAt: new Date().toISOString() };
  jobs.unshift(job); return res.status(201).json(job);
});
app.patch("/api/repair-jobs/:id/status", (req, res) => {
  const status = z.enum(statuses).safeParse(req.body.status);
  const job = jobs.find((item) => item.id === req.params.id);
  if (!job) return res.status(404).json({ message: "Repair job not found." });
  if (!status.success) return res.status(400).json({ message: "Invalid repair status." });
  job.status = status.data; return res.json(job);
});

app.listen(Number(process.env.PORT ?? 4000), () => console.log("FixMitra API running on http://localhost:4000"));
