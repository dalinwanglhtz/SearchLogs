public virtual class MockSearchLogDAOService implements SearchLogDAOService {
    public virtual List<ApexLog> getLogs() {
        return new List<ApexLog>(); 
    }
}