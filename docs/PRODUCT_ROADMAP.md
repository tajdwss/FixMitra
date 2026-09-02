# FixMitra product roadmap

## Product principle

The first release must make a repair counter fast, clear and auditable. Sales, used devices and SaaS administration will reuse the same customer, product, inventory, invoice and payment foundations.

## Phase 1 — Repair operations

1. Secure owner/staff login and business profile.
2. Customer search by phone with repair history.
3. Repair job card: category, device, IMEI/serial, received accessories, condition/photo, complaint, diagnosis, estimate and advance.
4. Status timeline: Received → Inspection → Estimate → Approved → Parts → Repair → QC → Ready → Delivered.
5. WhatsApp/SMS template events for received, estimate approval, ready and delivery.
6. Technician assignment, task notes, photo proof and quality check.
7. Invoice, balance collection, warranty and delivery signature/OTP.

## Phase 2 — Inventory and accounts

- Parts catalog, compatible device models, suppliers, stock locations, purchase, stock movement and reorder alerts.
- Parts consumed against repair job; cost and margin reporting.
- Expenses, cash/UPI/card/bank collection, credit customer ledger and day-close report.

## Phase 3 — Sales and used devices

- Barcode POS, serial/IMEI sales, GST invoice, return/replacement and product warranty.
- Used-device acquisition with seller declaration, device condition grading, IMEI duplicate warning, refurbishment cost, data-wipe record and resale warranty.
- Exchange/buyback valuation connected to new-device invoice.

## Phase 4 — SaaS scale

- Tenant isolation, subscription/billing, role permissions, audit log, branch-level access and white-label branding.
- Customer tracking portal, staff Android/iOS app, pickup/delivery and AMC/field service.

## Required data safety rules

- Never store device passwords in plain text; use short-lived encrypted access data or customer-present unlock.
- Device condition and received accessories require timestamped customer acknowledgement.
- IMEI must be validated and must never silently overwrite a prior record.
- Every price, stock, status and invoice change is audited with user, time and branch.
- Tenant data is isolated at database-query level, not only UI level.
