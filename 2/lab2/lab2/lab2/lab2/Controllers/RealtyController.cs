using lab2.DataAccess;
using lab2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace lab2.Controllers
{
    public class RealtyController : Controller
    {

        // GET: Realty

        [HttpGet]
        public ActionResult Navigation()
        {
            return View();
        }

        [HttpGet]
        public ActionResult ShowAllRealty()
        {
            Realty objRealty = new Realty();
            DataAccessLayerRealty objDB = new DataAccessLayerRealty(); //calling class DBdata
            objRealty.ShowAllRealty = objDB.SelectAllData();

            return View(objRealty);
        }

        [HttpGet]
        public ActionResult Edit(string ID)
        {
            Realty objRealty = new Realty();
            DataAccessLayerRealty objDB = new DataAccessLayerRealty(); //calling class DBdata

            return View(objDB.SelectDatabyID(ID));
        }

        [HttpPost]
        public ActionResult Edit(Realty objRealty)
        {
            if (ModelState.IsValid) //checking model is valid or not
            {
                DataAccessLayerRealty objDB = new DataAccessLayerRealty(); //calling class DBdata
                string result = objDB.UpdateData(objRealty);
                ViewData["result"] = result;
                ModelState.Clear(); //clearing model

                return View();
            }
            else
            {
                ModelState.AddModelError("", "Error in saving data");

                return View();
            }
        }

        [HttpGet]
        public ActionResult Delete(string ID)
        {
            Realty objRealty = new Realty();
            DataAccessLayerRealty objDB = new DataAccessLayerRealty(); //calling class DBdata

            return View(objDB.SelectDatabyID(ID));
        }

        [HttpPost]
        public ActionResult Delete(int id)
        {
            DataAccessLayerRealty objDB = new DataAccessLayerRealty();
            string result = objDB.DeleteData(id);
            ViewData["result"] = result;
            ModelState.Clear(); //clearing model

            return View();
        }

        [HttpGet]
        public ActionResult InsertRealty(string ID)
        {
            Realty objCustomer = new Realty();
            DataAccessLayerRealty objDB = new DataAccessLayerRealty(); //calling class DBdata

            return View(objDB.SelectDatabyID(ID));
        }

        [HttpPost]
        public ActionResult InsertRealty(Realty objRealty)
        {
            if (ModelState.IsValid) //checking model is valid or not
            {
                DataAccessLayerRealty objDB = new DataAccessLayerRealty();
                string result = objDB.InsertData(objRealty);
                ViewData["result"] = result;
                ModelState.Clear(); //clearing model

                return View();
            } 
            else
            {
                ModelState.AddModelError("", "Error in saving data");

                return View();
            }
        }
    }
}