using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using lab2.Models;

namespace lab2.DataAccess
{
    public class DataAccessLayerContract
    {
        public string InsertData(IContract objcust)
        {
            SqlConnection con = null;
            string result = "";

            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Contract", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@ContractID", 0);
                cmd.Parameters.AddWithValue("@RealtyID", objcust.realtyid);
                cmd.Parameters.AddWithValue("@RealtorID", objcust.realtorid);
                cmd.Parameters.AddWithValue("@FareCode", objcust.fare_code);
                cmd.Parameters.AddWithValue("@Term", objcust.term);
                cmd.Parameters.AddWithValue("@SignDate", objcust.sign_date);
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

        public string UpdateData(IContract objcust)
        {
            SqlConnection con = null;
            string result = "";
            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Contract", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ContractID", objcust.contract_id);
                cmd.Parameters.AddWithValue("@RealtyID", objcust.realtyid);
                cmd.Parameters.AddWithValue("@RealtorID", objcust.realtorid);
                cmd.Parameters.AddWithValue("@FareCode", objcust.fare_code);
                cmd.Parameters.AddWithValue("@Term", objcust.term);
                cmd.Parameters.AddWithValue("@SignDate", objcust.sign_date);
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
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Contract", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ContractID", id);
                cmd.Parameters.AddWithValue("@RealtyID", null);
                cmd.Parameters.AddWithValue("@RealtorID", null);
                cmd.Parameters.AddWithValue("@FareCode", null);
                cmd.Parameters.AddWithValue("@Term", null);
                cmd.Parameters.AddWithValue("@SignDate", null);
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

        public List<IContract> SelectAllData()
        {
            SqlConnection con = null;
            DataSet ds = null;
            List<IContract> contractlist = null;

            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Contract", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ContractID", null);
                cmd.Parameters.AddWithValue("@RealtyID", null);
                cmd.Parameters.AddWithValue("@RealtorID", null);
                cmd.Parameters.AddWithValue("@FareCode", null);
                cmd.Parameters.AddWithValue("@Term", null);
                cmd.Parameters.AddWithValue("@SignDate", null);
                cmd.Parameters.AddWithValue("@Query", 4);

                con.Open();
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                ds = new DataSet();
                da.Fill(ds);
                contractlist = new List<IContract>();

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    IContract cobj = new IContract();
                    cobj.contract_id = Convert.ToInt32(ds.Tables[0].Rows[i]["contract_id"].ToString());
                    cobj.realtyid = Convert.ToInt32(ds.Tables[0].Rows[i]["realtyid"].ToString());
                    cobj.realtorid = Convert.ToInt32(ds.Tables[0].Rows[i]["realtorid"].ToString());
                    cobj.fare_code = Convert.ToInt32(ds.Tables[0].Rows[i]["fare_code"]);
                    cobj.term = Convert.ToInt32(ds.Tables[0].Rows[i]["term"].ToString());
                    cobj.sign_date = ds.Tables[0].Rows[i]["sign_date"].ToString().Remove(10);

                    contractlist.Add(cobj);
                }

                return contractlist;
            }
            catch
            {
                return contractlist;
            }
            finally
            {
                con.Close();
            }
        }

        public IContract SelectDatabyID(string ContractId)
        {
            SqlConnection con = null;
            DataSet ds = null;
            IContract cobj = null;

            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Contract", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ContractID", ContractId);
                cmd.Parameters.AddWithValue("@RealtyID", null);
                cmd.Parameters.AddWithValue("@RealtorID", null);
                cmd.Parameters.AddWithValue("@FareCode", null);
                cmd.Parameters.AddWithValue("@Term", null);
                cmd.Parameters.AddWithValue("@SignDate", null);
                cmd.Parameters.AddWithValue("@Query", 5);

                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                ds = new DataSet();
                da.Fill(ds);

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    cobj = new IContract();
                    cobj.contract_id = Convert.ToInt32(ds.Tables[0].Rows[i]["contract_id"].ToString());
                    cobj.realtyid = Convert.ToInt32(ds.Tables[0].Rows[i]["realtyid"].ToString());
                    cobj.realtorid = Convert.ToInt32(ds.Tables[0].Rows[i]["realtorid"].ToString());
                    cobj.fare_code = Convert.ToInt32(ds.Tables[0].Rows[i]["fare_code"]);
                    cobj.term = Convert.ToInt32(ds.Tables[0].Rows[i]["term"].ToString());
                    cobj.sign_date = ds.Tables[0].Rows[i]["sign_date"].ToString().Remove(10);
                }

                return cobj;
            }
            catch
            {
                return cobj;
            }
            finally
            {
                con.Close();
            }
        }

        public List<IContract> SelectContractsWithDate(string start_date, string end_date)
        {
            SqlConnection con = null;
            DataSet ds = null;
            List<IContract> contractlist = null;

            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ToString());
                SqlCommand cmd = new SqlCommand("Usp_InsertUpdateDelete_Contract", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ContractID", null);
                cmd.Parameters.AddWithValue("@RealtyID", null);
                cmd.Parameters.AddWithValue("@RealtorID", null);
                cmd.Parameters.AddWithValue("@FareCode", null);
                cmd.Parameters.AddWithValue("@Term", null);
                cmd.Parameters.AddWithValue("@SignDate", null);
                cmd.Parameters.AddWithValue("@StartDate", start_date);
                cmd.Parameters.AddWithValue("@EndDate", end_date);
                cmd.Parameters.AddWithValue("@Query", 6);

                con.Open();
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                ds = new DataSet();
                da.Fill(ds);
                contractlist = new List<IContract>();

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    IContract cobj = new IContract();
                    cobj.contract_id = Convert.ToInt32(ds.Tables[0].Rows[i]["contract_id"].ToString());
                    cobj.realtyid = Convert.ToInt32(ds.Tables[0].Rows[i]["realtyid"].ToString());
                    cobj.realtorid = Convert.ToInt32(ds.Tables[0].Rows[i]["realtorid"].ToString());
                    cobj.fare_code = Convert.ToInt32(ds.Tables[0].Rows[i]["fare_code"]);
                    cobj.term = Convert.ToInt32(ds.Tables[0].Rows[i]["term"].ToString());
                    cobj.sign_date = ds.Tables[0].Rows[i]["sign_date"].ToString().Remove(10);

                    contractlist.Add(cobj);
                }

                return contractlist;
            }
            catch
            {
                return contractlist;
            }
            finally
            {
                con.Close();
            }
        }
    }
}