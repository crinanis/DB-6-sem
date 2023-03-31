using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace lab2.Models
{
    public class Realty
    {
        [Key]
        public int realty_id { get; set; }
        [Required(ErrorMessage = "Enter realty type")]
        public string realty_type { get; set; }
        [Required(ErrorMessage = "Enter area")]
        public float area { get; set; }
        [Required(ErrorMessage = "Enter realty address")]
        public string realty_address { get; set; }
        [Required(ErrorMessage = "Enter realty cost")]
        public float cost { get; set; }
        [Required(ErrorMessage = "Enter owner id")]
        public int ownerid { get; set; }
        public List<Realty> ShowAllRealty { get; set; }
    }
}