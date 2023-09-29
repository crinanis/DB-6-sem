using lab2.DataAccess;
using lab2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace lab2.Controllers
{
    public class ContractController : Controller
    {
        // GET: Contract
        [HttpGet]
        public ActionResult Navigation()
        {
            return View();
        }

        [HttpGet]
        public ActionResult ShowAllContracts()
        {
            IContract objContract = new IContract();
            DataAccessLayerContract objDB = new DataAccessLayerContract(); //calling class DBdata
            objContract.ShowAllContracts = objDB.SelectAllData();

            return View(objContract);
        }

        [HttpGet]
        public ActionResult Edit(string ID)
        {
            IContract objContract = new IContract();
            DataAccessLayerContract objDB = new DataAccessLayerContract(); //calling class DBdata

            return View(objDB.SelectDatabyID(ID));
        }

        [HttpPost]
        public ActionResult Edit(IContract objContract)
        {
            if (ModelState.IsValid) //checking model is valid or not
            {
                DataAccessLayerContract objDB = new DataAccessLayerContract(); //calling class DBdata
                string result = objDB.UpdateData(objContract);
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
            DataAccessLayerContract objDB = new DataAccessLayerContract(); //calling class DBdata

            return View(objDB.SelectDatabyID(ID));
        }

        [HttpPost]
        public ActionResult Delete(int id)
        {
            DataAccessLayerContract objDB = new DataAccessLayerContract();
            string result = objDB.DeleteData(id);
            ViewData["result"] = result;
            ModelState.Clear(); //clearing model

            return View();
        }

        [HttpGet]
        public ActionResult Insert(string ID)
        {
            DataAccessLayerContract objDB = new DataAccessLayerContract(); //calling class DBdata
            return View(objDB.SelectDatabyID(ID));
        }

        [HttpPost]
        public ActionResult Insert(IContract objContract)
        {
            if (ModelState.IsValid) //checking model is valid or not
            {
                DataAccessLayerContract objDB = new DataAccessLayerContract();
                string result = objDB.InsertData(objContract);
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