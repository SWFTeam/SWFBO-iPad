//
//  Database.swift
//  SWFBO
//
//  Created by Julien Guillan on 29/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation
import SQLite3
import os.log

class DBHelper
{
    init()
    {
        //print("Table creation:", dropTable(tableName: "user"))
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "SWFBO.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }


    /**
            This function will create the table after checking if the table exists
            - Throws:"user table could not be created."
                     if sqlite3_step is different from "SQLITE_DONE"
                     "CREATE TABLE statement could not be prepared."
                     if sqlite3_prepare_v2 is different from "SQLITE_OK"
            - Returns: None
     */
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(Id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, lastname TEXT, email TEXT, token TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user table created.")
            } else {
                print("user table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }


    /**
           This function will add entries in the database
           - Throws:"Could not insert row."
                    if sqlite3_step is different from "SQLITE_DONE"
                    "CREATE TABLE statement could not be prepared."
                    if sqlite3_prepare_v2 is different from "SQLITE_OK"
           - Returns: None
    */
    func insert(id:Int, firstname: String, lastname: String, email: String, token: String)
    {
        let insertStatementString = "INSERT INTO user (Id, firstname, lastname, email, token) VALUES (NULL, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (firstname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (lastname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (token as NSString).utf8String, -1, nil)
            let result = sqlite3_step(insertStatement)
            if result == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
                print(result)
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }



    /**
           This Function will read all the Entries in the database
     
           - Throws:"CREATE TABLE statement could not be prepared."
                    if sqlite3_prepare_v2 is different from "SQLITE_OK"
           - Returns: A User table
    */
    func readAll() -> [User] {
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let firstname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lastname = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let token = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                users.append(User(id: Int(id), firstname: firstname, lastname: lastname, email: email, token: token))
                print("Query Result:")
                print("\(id) | \(firstname) | \(lastname) | \(email) | \(token)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }

    /**
     This Function will read all the Entries in the database having the definied Id
     - Parameter id : The wanted id
     - Throws:"CREATE TABLE statement could not be prepared."
            if sqlite3_prepare_v2 is different from "SQLITE_OK"
     - Returns: A User table
    */
    func selectWhereId(id:Int) -> User {
        let queryStatementString = "SELECT * FROM user WHERE Id = ? LIMIT 1;"
        var queryStatement: OpaquePointer? = nil
        var user: User = User(id: id)
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(id))
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let firstname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lastname = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let token = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                if(email != nil){
                    user = User(id: Int(id), firstname: firstname, lastname: lastname, email: email, token: token)
                } else {
                    user = User(id: Int(id), firstname: "nil", lastname: "nil", email: "nil", token: "nil")
                }
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return user
    }


    /**
           This Function will read all the Entries in the database having the definied Id
           - Parameter id : The wanted id
           - Throws:"Could not delete row."
                    if sqlite3_step is different from "SQLITE_DONE"
                    "CREATE TABLE statement could not be prepared."
                    if sqlite3_prepare_v2 is different from "SQLITE_OK"
           - Returns: None
    */
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM user WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func dropTable(tableName: String) -> Bool {
        let dropStatementString = "DROP TABLE IF EXISTS " + tableName
        var dropStatement: OpaquePointer? = nil
        var state = false
        if sqlite3_prepare_v2(self.db, dropStatementString, -1, &dropStatement, nil) == SQLITE_OK {
            let result = sqlite3_step(dropStatement)
            if(result == SQLITE_OK){
                print("TABLE DELETED SUCCESSFULLY")
                state = true
            }
        }
        return state
    }

}

