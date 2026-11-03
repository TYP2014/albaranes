-- v1033 · Bandeja de entrada de GASOIL (facturas que llegan por correo)
-- Ejecutar ANTES de subir la v1033. Una sentencia cada vez.

-- 1) La tabla
create table if not exists public.gasoil_entrada (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  buzon text,                 -- gmail donde llegó (tteshispalis2016@gmail.com, ...)
  gmail_msg_id text unique,   -- candado: el robot no apunta dos veces el mismo correo
  remitente text,
  asunto text,
  fecha_correo timestamptz,
  proveedor text,             -- Solred / Petromiralles / Moeve / Soledad
  empresa text,               -- TYP2014 | HISPALIS | TRANSMARGAZ | PORTES (por el CIF del asunto o del buzón)
  mes text,                   -- 'AAAA-MM' (del asunto, si lo trae)
  archivo_nombre text,
  archivo_path text not null, -- ruta en el bucket documentos
  estado text not null default 'pendiente',   -- pendiente | leida | descartada
  leida_por text,
  leida_en timestamptz
);

-- 2) Seguridad: solo admin y gestor la ven/tocan desde la app
alter table public.gasoil_entrada enable row level security;

create policy gasoil_entrada_admin_gestor on public.gasoil_entrada
  for all to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin','gestor')))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin','gestor')));

-- 3) GRANTs (obligatorios desde el 30/10/2026)
grant select, insert, update, delete on public.gasoil_entrada to authenticated;

grant select, insert, update, delete on public.gasoil_entrada to service_role;

-- Comprobación: debe devolver 0 filas y sin error
select id, proveedor, empresa, mes, estado from public.gasoil_entrada limit 5;
