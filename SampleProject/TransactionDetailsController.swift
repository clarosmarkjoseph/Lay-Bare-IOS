//
//  TransactionDetailsController.swift
//  SampleProject
//
//  Created by Paolo Hilario on 6/26/18.
//  Copyright © 2018 itadmin. All rights reserved.
//
import Foundation
import UIKit

class TransactionDetailsController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var lblBranch: UILabel!
    @IBOutlet var lblinvoiceNo: UILabel!
    @IBOutlet var lblTransactionNo: UILabel!
    @IBOutlet var lblTransactionDate: UILabel!
    @IBOutlet var lblSubtotal: UILabel!
    @IBOutlet var lblTotalDiscount: UILabel!
    @IBOutlet var lblTotalPrice: UILabel!
    @IBOutlet var tblTransactionDetails: UITableView!
    var objectTransaction:ArrayUserTransactionData? = nil
    var arrayTransactionItems:[BossServiceFetched]? = nil
    let utilities = Utilities()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayTransactionItems                       = objectTransaction?.services
        tblTransactionDetails.rowHeight             = UITableViewAutomaticDimension
        tblTransactionDetails.estimatedRowHeight    = 90
        tblTransactionDetails.delegate              = self
        tblTransactionDetails.dataSource            = self
        loadTransaction()
    }
    
    func loadTransaction(){
       
        let transaction_branch      = objectTransaction?.branch ?? "N/A"
        let transaction_no          = utilities.getNumberValueInString(stringValue:"\( objectTransaction?.transaction_id)")
        let transaction_inv         = utilities.getNumberValueInString(stringValue: "\(objectTransaction?.inv)")
        let transaction_date        = objectTransaction?.date ?? "0000-00-00"
        
        let transaction_net         = utilities.getNumberValueInString(stringValue: "\(objectTransaction?.net_amount )")
        let transaction_discount    =  utilities.getNumberValueInString(stringValue: "\(objectTransaction?.price_discount)")
        
        var totalPrice      = 0.0
        let totalDiscount   = Double(transaction_discount) ?? 0.0
        let arrayService    = objectTransaction?.services!
        
        for row in arrayService!{
            let stringPrice = utilities.getNumberValueInString(stringValue: "\(row.sub_total)")
            let netPrice    = Double(stringPrice) ?? 0.0
            totalPrice+=netPrice
        }
        
        if(totalPrice <= 0){
            totalPrice = Double(transaction_net) ?? 0
        }
        let grossPrice  = totalPrice
        totalPrice      = totalPrice - totalDiscount
    
        lblBranch.text              = transaction_branch
        lblinvoiceNo.text           = "Invoice No: \(transaction_inv)"
        lblTransactionNo.text       = "\(transaction_no)"
        lblTransactionDate.text     = utilities.getCompleteDateString(stringDate: transaction_date)
        lblSubtotal.text            = "\(utilities.convertToStringCurrency(value: "\(grossPrice)" ))"
        lblTotalDiscount.text       = "\(utilities.convertToStringCurrency(value: "\(totalDiscount)"))"
        lblTotalPrice.text          = "\(utilities.convertToStringCurrency(value: "\(totalPrice)"))"
        tblTransactionDetails.reloadData()
    }
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTransactionItems!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell            = tblTransactionDetails.dequeueReusableCell(withIdentifier: "cellTransactionDetails") as! TransactionDataViewCell
        let position        = indexPath.row
        let item_name       = arrayTransactionItems![position].item_name!
        let item_unit       = arrayTransactionItems![position].item_unit!
        var item_quantity   = arrayTransactionItems![position].quantity
        var item_unit_price = arrayTransactionItems![position].unit_price
        let item_sub_total  = utilities.getNumberValueInString(stringValue: "\(arrayTransactionItems![position].sub_total)")
  
        let stringQuantity  = utilities.getNumberValueInString(stringValue: "\(item_quantity)")
        let stringUnitPrice = utilities.getNumberValueInString(stringValue: "\(item_unit_price)")
        
        let qty         = utilities.convertStringToDouble(stringValue: stringQuantity)
        let price       = utilities.convertStringToDouble(stringValue: stringUnitPrice)
        
        let sub_total   = qty * price
        if(item_unit == "Service"){
            cell.lblType.text = "Services"
        }
        else{
            cell.lblType.text = "Products - (\(item_unit))"
        }
        cell.lblItemName.text   = item_name
        cell.lblQuantity.text   = "\(stringQuantity) pc(s)"
        cell.lblUnitPrice.text  = utilities.convertToStringCurrency(value: stringUnitPrice)
        cell.lblSubtotal.text   = utilities.convertToStringCurrency(value: "\(sub_total)")
        return cell
    }
    
    
    
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(tableView.rowHeight >= 90.0){
//            return UITableViewAutomaticDimension
//        }
//        return 90.0
//    }

}
