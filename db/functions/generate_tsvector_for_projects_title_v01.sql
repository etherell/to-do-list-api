CREATE OR REPLACE FUNCTION generate_tsvector_for_projects_title()
RETURNS trigger
LANGUAGE plpgsql AS $generate_tsvector_for_projects_title$
BEGIN
  IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE' AND NEW.title != OLD.title) THEN
    NEW.title_tsvector := to_tsvector('pg_catalog.english', coalesce(NEW.title,''));
  END IF;

  RETURN NEW;
END;
$generate_tsvector_for_projects_title$
