namespace NetGuardApp.Models
{
    public class Sitio
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        
        public string TipoSitio { get; set; } = string.Empty;
        public string Ubicacion { get; set; } = string.Empty;
    }
}