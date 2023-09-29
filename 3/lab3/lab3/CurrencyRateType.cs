using System;
using System.Data.SqlTypes;
using System.Globalization;
using System.IO;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, MaxByteSize = 8000)]
public struct CurrencyRateType: INullable, Microsoft.SqlServer.Server.IBinarySerialize
{
    public string CurrencyCode;
    public decimal BuyRate;
    public decimal SellRate;
    public DateTime Date;
    public override string ToString()
    {
        // Заменить на собственный код
        return CurrencyCode + BuyRate + SellRate + Date;
    }
    
    public bool IsNull
    {
        get
        {
            // Введите здесь код
            return _null;
        }
    }
    
    public static CurrencyRateType Null
    {
        get
        {
            CurrencyRateType h = new CurrencyRateType();
            h._null = true;
            return h;
        }
    }
    
    public static CurrencyRateType Parse(SqlString s)
    {
        string[] a = s.Value.Split('-'); 
        if (s.IsNull)
            return Null;
        CurrencyRateType u = new CurrencyRateType
        {
            CurrencyCode = a[0],
            BuyRate = decimal.Parse(a[1], NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture),
            SellRate = decimal.Parse(a[2], NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture),
            Date = Convert.ToDateTime(a[3])
        };
        // Введите здесь код
        return u;
    }
    
    // Это метод-заполнитель
    public string Method1()
    {
        // Введите здесь код
        return string.Empty;
    }
    
    // Это статический метод заполнителя
    public static SqlString Method2()
    {
        // Введите здесь код
        return new SqlString("");
    }

    public void Read(BinaryReader r)
    {
        CurrencyCode = r.ReadString();
    }

    public void Write(BinaryWriter w)
    {
        w.Write($"Код валюты: {CurrencyCode}, курс покупки: {BuyRate}, курс продажи: {SellRate}, дата: {Date.Date}");
    }

    // Это поле элемента-заполнителя
    public int _var1;
 
    // Закрытый член
    private bool _null;
}