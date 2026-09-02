export type RepairStatus =
  | "RECEIVED"
  | "INSPECTION"
  | "ESTIMATE_SENT"
  | "APPROVED"
  | "WAITING_FOR_PARTS"
  | "IN_PROGRESS"
  | "QUALITY_CHECK"
  | "READY"
  | "DELIVERED"
  | "CANCELLED";

export interface Customer {
  id: string;
  name: string;
  phone: string;
  alternatePhone?: string;
}

export interface RepairJob {
  id: string;
  ticketNo: string;
  customer: Customer;
  category: "MOBILE" | "ELECTRONICS";
  product: string;
  brand?: string;
  model?: string;
  imei1?: string;
  imei2?: string;
  quantity: number;
  complaint: string;
  estimatedAmount?: number;
  status: RepairStatus;
  createdAt: string;
}
