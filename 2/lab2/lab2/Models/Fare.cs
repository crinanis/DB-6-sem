using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace lab2.Models
{
    public class Fare
    {
        [Key]
        public int FareId { get; set; }
        [Required(ErrorMessage = "Enter title")]
        public string Title { get; set; }
        [Required(ErrorMessage = "Enter IntRate6")]
        public float IntRate6 { get; set; }
        [Required(ErrorMessage = "Enter IntRate12")]
        public float IntRate12 { get; set; }
        [Required(ErrorMessage = "Enter IntRate36")]
        public float IntRate36 { get; set; }
        public List<Fare> ShowAllFares { get; set; }

    }
}