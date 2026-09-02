-- FixMitra: multi-tenant repair, sales and service foundation.
create extension if not exists pgcrypto;

create table if not exists public.tenants (
  id uuid primary key default gen_random_uuid(),
  name varchar(160) not null,
  slug varchar(80) not null unique,
  phone varchar(20),
  created_at timestamptz not null default now()
);

create table if not exists public.users (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  name varchar(120) not null,
  phone varchar(20) not null,
  password_hash text not null,
  role varchar(30) not null check (role in ('OWNER','MANAGER','RECEPTION','TECHNICIAN','SALES','ACCOUNTANT')),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (tenant_id, phone)
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  name varchar(160) not null,
  phone varchar(20) not null,
  alternate_phone varchar(20),
  email varchar(160),
  address text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (tenant_id, phone)
);

create table if not exists public.repair_jobs (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  customer_id uuid not null references public.customers(id),
  ticket_no varchar(30) not null,
  category varchar(30) not null check (category in ('MOBILE','ELECTRONICS')),
  product varchar(160) not null,
  brand varchar(100),
  model varchar(120),
  imei_1 varchar(40),
  imei_2 varchar(40),
  serial_no varchar(80),
  quantity integer not null default 1 check (quantity > 0),
  complaint text not null,
  diagnosis text,
  estimated_amount numeric(12,2),
  final_amount numeric(12,2),
  advance_amount numeric(12,2) not null default 0,
  status varchar(30) not null default 'RECEIVED',
  assigned_to uuid references public.users(id),
  expected_delivery_at timestamptz,
  warranty_days integer not null default 0,
  created_by uuid references public.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (tenant_id, ticket_no)
);

create table if not exists public.repair_status_events (
  id uuid primary key default gen_random_uuid(),
  repair_job_id uuid not null references public.repair_jobs(id) on delete cascade,
  old_status varchar(30),
  new_status varchar(30) not null,
  note text,
  changed_by uuid references public.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  user_id uuid references public.users(id),
  entity_type varchar(50) not null,
  entity_id uuid,
  action varchar(80) not null,
  payload jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_customers_tenant_phone on public.customers(tenant_id, phone);
create index if not exists idx_repair_jobs_tenant_status on public.repair_jobs(tenant_id, status);
create index if not exists idx_repair_jobs_tenant_imei on public.repair_jobs(tenant_id, imei_1);

alter table public.tenants enable row level security;
alter table public.users enable row level security;
alter table public.customers enable row level security;
alter table public.repair_jobs enable row level security;
alter table public.repair_status_events enable row level security;
alter table public.audit_logs enable row level security;

-- The API uses the server-side database connection. Browser/mobile clients never
-- receive direct table access; RLS is enabled now as a defence-in-depth default.
