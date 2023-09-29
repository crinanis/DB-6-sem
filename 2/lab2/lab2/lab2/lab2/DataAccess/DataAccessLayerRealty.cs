using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using lab2.Models;

namespace lab2.DataAccess
{
    public class DataAccessLayerRealty
    {
        public string InsertData(Realty objcust)
        {
            SqlConnection con = null;
            string result = "";

            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Realty", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@RealtyId", 0);
                cmd.Parameters.AddWithValue("@RealtyType", objcust.realty_type);
                cmd.Parameters.AddWithValue("@Area", objcust.area);
                cmd.Parameters.AddWithValue("@Cost", objcust.cost);
                cmd.Parameters.AddWithValue("@RealtyAddress", objcust.realty_address);
                cmd.Parameters.AddWithValue("@OwnerId", objcust.ownerid);
                cmd.Parameters.AddWithValue("@Query", 1);

                con.Open();
                result = cmd.ExecuteScalar().ToString();
                return result;

            }
            catch
            {
                return result = "";
            }
            finally
            {
                con.Close();
            }
        }

        public string UpdateData(Realty objcust)
        {
            SqlConnection con = null;
            string result = "";
            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Realty", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@RealtyId", objcust.realty_id);
                cmd.Parameters.AddWithValue("@RealtyType", objcust.realty_type);
                cmd.Parameters.AddWithValue("@Area", objcust.area);
                cmd.Parameters.AddWithValue("@Cost", objcust.cost);
                cmd.Parameters.AddWithValue("@RealtyAddress", objcust.realty_address);
                cmd.Parameters.AddWithValue("@OwnerId", objcust.ownerid);
                cmd.Parameters.AddWithValue("@Query", 2);

                con.Open();
                result = cmd.ExecuteScalar().ToString();

                return result;
            }
            catch
            {
                return result = "";
            }

            finally
            {
                con.Close();
            }
        }

        public string DeleteData(int id)
        {
            SqlConnection con = null;
            string result = "";
            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Realty", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@RealtyId", id);
                cmd.Parameters.AddWithValue("@RealtyType", null);
                cmd.Parameters.AddWithValue("@Area", null);
                cmd.Parameters.AddWithValue("@Cost", null);
                cmd.Parameters.AddWithValue("@RealtyAddress", null);
                cmd.Parameters.AddWithValue("@OwnerId", null);
                cmd.Parameters.AddWithValue("@Query", 3);
                con.Open();

                result = cmd.ExecuteScalar().ToString();

                return result;
            }

            catch
            {
                return result = "";
            }

            finally
            {
                con.Close();
            }
        }

        public List<Realty> SelectAllData()
        {
            SqlConnection con = null;
            DataSet ds = null;
            List<Realty> realtylist = null;

            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Realty", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@RealtyId", null);
                cmd.Parameters.AddWithValue("@RealtyType", null);
                cmd.Parameters.AddWithValue("@Area", null);
                cmd.Parameters.AddWithValue("@Cost", null);
                cmd.Parameters.AddWithValue("@RealtyAddress", null);
                cmd.Parameters.AddWithValue("@OwnerId", null);
                cmd.Parameters.AddWithValue("@Query", 4);

                con.Open();
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                ds = new DataSet();
                da.Fill(ds);
                realtylist = new List<Realty>();

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    Realty robj = new Realty();
                    robj.realty_id = Convert.ToInt32(ds.Tables[0].Rows[i]["realty_id"].ToString());
                    robj.realty_type = ds.Tables[0].Rows[i]["realty_type"].ToString();
                    robj.realty_address = ds.Tables[0].Rows[i]["realty_address"].ToString();
                    robj.area = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["area"]);
                    robj.cost = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["cost"].ToString());
                    robj.ownerid = Convert.ToInt32(ds.Tables[0].Rows[i]["ownerid"].ToString());

                    realtylist.Add(robj);
                }

                return realtylist;
            }

            catch
            {
                return realtylist;
            }

            finally
            {
                con.Close();
            }
        }

        public Realty SelectDatabyID(string RealtyId)
        {
            SqlConnection con = null;
            DataSet ds = null;
            Realty robj = null;

            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Realty", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@RealtyId", RealtyId);
                cmd.Parameters.AddWithValue("@RealtyType", null);
                cmd.Parameters.AddWithValue("@Cost", null);
                cmd.Parameters.AddWithValue("@Area", null);
                cmd.Parameters.AddWithValue("@RealtyAddress", null);
                cmd.Parameters.AddWithValue("@OwnerId", null);
                cmd.Parameters.AddWithValue("@Query", 5);

                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                ds = new DataSet();
                da.Fill(ds);

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    robj = new Realty();
                    robj.realty_id = Convert.ToInt32(ds.Tables[0].Rows[i]["realty_id"].ToString());
                    robj.realty_type = ds.Tables[0].Rows[i]["realty_type"].ToString();
                    robj.realty_address = ds.Tables[0].Rows[i]["realty_address"].ToString();
                    robj.cost = (float) Convert.ToDouble(ds.Tables[0].Rows[i]["cost"].ToString());
                    robj.area = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["area"].ToString());
                    robj.ownerid = Convert.ToInt32(ds.Tables[0].Rows[i]["ownerid"].ToString());
                }

                return robj;
            }

            catch
            {
                return robj;
            }

            finally
            {
                con.Close();
            }
        }
    }
}