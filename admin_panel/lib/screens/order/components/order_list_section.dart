import 'package:admin/utility/extensions.dart';
import 'package:admin/utility/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/order.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import '../provider/order_provider.dart';

class OrderListSection extends StatelessWidget {
  const OrderListSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            return DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Customer Name"),
                ),
                DataColumn(
                  label: Text("Order Amount"),
                ),
                DataColumn(
                  label: Text("Payment"),
                ),
                DataColumn(
                  label: Text("Status / Edit"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Delete"),
                ),
              ],
              rows: List.generate(
                dataProvider.orders.length,
                (index) => orderDataRow(
                    context, dataProvider.orders[index], index + 1, delete: () {
                  context.orderProvider.deleteOrder(dataProvider.orders[index]);
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

DataRow orderDataRow(BuildContext context, Order orderInfo, int index,
    {Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(
                index.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(orderInfo.userID?.name ?? ''),
            ),
          ],
        ),
      ),
      DataCell(Text('${orderInfo.orderTotal?.total}')),
      DataCell(Text(orderInfo.paymentMethod ?? '')),
      DataCell(
        Container(
          width: 150,
          child: Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              return DropdownButtonFormField<String>(
                initialValue: orderInfo.orderStatus ?? ORDER_STATUS_PENDING,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: secondaryColor,
                ),
                style: TextStyle(fontSize: 12, color: Colors.white),
                dropdownColor: secondaryColor,
                items: [
                  ORDER_STATUS_PENDING,
                  ORDER_STATUS_PROCESSING,
                  ORDER_STATUS_SHIPPED,
                  ORDER_STATUS_DELIVERED,
                  ORDER_STATUS_CANCELLED
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white, fontSize: 12)),
                  );
                }).toList(),
                onChanged: (newValue) async {
                  if (newValue != null && newValue != orderInfo.orderStatus) {
                    // Update order status immediately
                    orderProvider.setDataForUpdate(orderInfo);
                    orderProvider.selectedOrderStatus = newValue;
                    await orderProvider.updateOrder();
                  }
                },
              );
            },
          ),
        ),
      ),
      DataCell(Text(formatTimestamp(context, orderInfo.orderDate))),
      DataCell(IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ],
  );
}
