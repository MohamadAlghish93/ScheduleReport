# Copyright (c)
## Developer by the Alghish
### Write, Read Database class


function SQL-Select($sqlText, $database , $server , $username, $password)
{
    $connection = new-object System.Data.SqlClient.SQLConnection("Initial Catalog=$database;Data Source=$server;User ID= $username;Password=$password");
    $cmd = new-object System.Data.SqlClient.SqlCommand($sqlText, $connection);

    $connection.Open();    

    Try {
        $reader = $cmd.ExecuteReader()

        $results = @()
        while ($reader.Read())
        {
            $row = @{}
            #echo $reader.GetValue(0)
            for ($i = 0; $i -lt $reader.FieldCount; $i++)
            {
                $row[$reader.GetName($i)] = $reader.GetValue($i)
            }
            $results += new-object psobject -property $row            
        }
    }
    Catch {
        Log-Message "Query: $($sqlText)" "Error"
        Log-Message "Error: $($_.Exception.Message)" "Error" 
    }

    $connection.Close();

    return $results
}

function SQL-Execute-CUD($sqlText, $database , $server , $username, $password)
{
     
    $connection = new-object System.Data.SqlClient.SQLConnection("Initial Catalog=$database;Data Source=$server;User ID= $username;Password=$password");
    $cmd = new-object System.Data.SqlClient.SqlCommand($sqlText, $connection);

    $connection.Open();
    
    Try {

        $cmd.CommandText = $sqlText  
        $results = $cmd.ExecuteNonQuery()

    
        if ($results -eq 0) {
       
           Log-Message "Query failed run: $sqlText" "Error"
        }
    }
    Catch {
        Log-Message "Query: $($sqlText)" "Error"
        Log-Message "Error: $($_.Exception.Message)" "Error" 
    }
    
    $connection.Close();   
}