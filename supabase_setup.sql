-- SQL Script to Set Up Your Supabase Database
-- Copy and paste this directly into the "SQL Editor" in your Supabase Dashboard

-- 1. Create Drivers Table
CREATE TABLE IF NOT EXISTS public.drivers (
    id text PRIMARY KEY,
    name text NOT NULL,
    busnumber text NOT NULL,
    password text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Create Routes Table
CREATE TABLE IF NOT EXISTS public.routes (
    id text PRIMARY KEY,
    name text NOT NULL,
    waypoints jsonb,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Create Active Buses Table
CREATE TABLE IF NOT EXISTS public.active_buses (
    driver_id text PRIMARY KEY REFERENCES public.drivers(id) ON DELETE CASCADE,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
    route_id text NOT NULL,
    crowd_status text DEFAULT 'Empty',
    passenger_count integer DEFAULT 0,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable realtime subscriptions for active_buses
alter publication supabase_realtime add table public.active_buses;

-- 4. Create Location History Table
CREATE TABLE IF NOT EXISTS public.location_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id text NOT NULL,
    route_id text NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Create Broadcasts Table
CREATE TABLE IF NOT EXISTS public.broadcasts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    message text NOT NULL,
    type text DEFAULT 'info',
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable realtime subscriptions for broadcasts
alter publication supabase_realtime add table public.broadcasts;

-- 6. Create Traffic Reports Table
CREATE TABLE IF NOT EXISTS public.traffic_reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    bus_id text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Security: Disable Row Level Security temporarily to get your app running quickly 
-- (You can re-enable and configure this later for production)
ALTER TABLE public.drivers DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.routes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.active_buses DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.location_history DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.broadcasts DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.traffic_reports DISABLE ROW LEVEL SECURITY;
