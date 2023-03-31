using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace lab2.Models
{
    public class Realtor
    {
        [Key]
        public int RealtorId { get; set; }
        [Required(ErrorMessage = "Enter realtor nsp")]
        public string RealtorNSP { get; set; }
        [Required(ErrorMessage = "Enter realtor address")]
        public string RealtorAddress { get; set; }
        [Required(ErrorMessage = "Enter realtor number")]
        public string RealtorNumber { get; set; }
        [Required(ErrorMessage = "Enter realtor agency")]
        public string Agency { get; set; }
        public List<Realtor> ShowAllReltors { get; set; }

    }
}