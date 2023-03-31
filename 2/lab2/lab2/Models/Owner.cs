using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace lab2.Models
{
    public class Owner
    {
        [Key]
        public int OwnerId { get; set; }
        [Required(ErrorMessage = "Enter owner name")]
        public string OwnerName { get; set; }
        [Required(ErrorMessage = "Enter owner surname")]
        public string OwnerSurname { get; set; }
        [Required(ErrorMessage = "Enter owner patronimyc")]
        public string OwnerPatronimyc { get; set; }
        [Required(ErrorMessage = "Enter owner address")]
        public string OwnerAddress { get; set; }
        [Required(ErrorMessage = "Enter owner number")]
        public string OwnerNumber { get; set; }
        [Required(ErrorMessage = "Enter owner passport")]
        public string OwnerPassport { get; set; }
        public List<Owner> ShowAllOwners { get; set; }

    }
}