-- v1054: tarjeta CHEQUE MOTIVA en la ficha del trabajador (EJECUTAR ANTES de subir la v1054)
-- Tabla ya existente: no hace falta GRANT. No borra ni cambia nada.
alter table public.trabajadores
  add column if not exists chm_registro text,
  add column if not exists chm_clave    text,
  add column if not exists chm_tarjeta  text;
