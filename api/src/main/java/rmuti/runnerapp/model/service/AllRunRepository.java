package rmuti.runnerapp.model.service;

import org.springframework.data.jpa.repository.JpaRepository;
import rmuti.runnerapp.model.table.AllRun;

public interface AllRunRepository extends JpaRepository<AllRun,Integer> {
}
