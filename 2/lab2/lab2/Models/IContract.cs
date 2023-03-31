using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace lab2.Models
{
    public class IContract
    {
        [Key]
        public int contract_id { get; set; }
        [Required(ErrorMessage = "Enter realty id")]
        public int realtyid { get; set; }
        [Required(ErrorMessage = "Enter realtor id")]
        public int realtorid { get; set; }
        [Required(ErrorMessage = "Enter fare code")]
        public int fare_code { get; set; }
        [Required(ErrorMessage = "Enter term")]
        public int term { get; set; }
        [Required(ErrorMessage = "Enter sign date")]
        public String sign_date { get; set; }
        public String start_date { get; set; }
        public String end_date { get; set; }
        public List<IContract> ShowAllContracts { get; set; }

    }
}