CREATE TRIGGER generate_tsvector_for_projects_title
  BEFORE INSERT OR UPDATE ON projects
  FOR EACH ROW
  EXECUTE PROCEDURE generate_tsvector_for_projects_title();
