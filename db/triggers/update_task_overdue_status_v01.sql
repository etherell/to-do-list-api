CREATE TRIGGER update_task_overdue_status
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE PROCEDURE update_task_overdue_status();
