CREATE OR REPLACE FUNCTION update_task_overdue_status()
RETURNS trigger
LANGUAGE plpgsql AS $update_task_overdue_status$
  BEGIN
	IF NEW.is_done = true THEN
		IF  NEW.deadline > NOW() THEN
			NEW.overdue_status = 1;
		ELSE
			NEW.overdue_status = 0;
		END IF;
	END IF;

  RETURN NEW;
END;
$update_task_overdue_status$
