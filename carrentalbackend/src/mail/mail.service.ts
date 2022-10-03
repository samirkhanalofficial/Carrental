import { MailerService } from '@nestjs-modules/mailer';
import { Injectable } from '@nestjs/common';
import { OrderDocument } from 'src/carrental/entities/order.entity';
import { PackageDocument } from 'src/carrental/entities/package.entity';

@Injectable()
export class MailService {
  constructor(private mailerService: MailerService) {}

  async sendOrdermail(
    email: string,
    name: string,
    order: OrderDocument,
    packagedetail: PackageDocument,
  ) {
    await this.mailerService.sendMail({
      to: email,
      subject: 'CarRental Booking Order',
      template: './order-added',
      context: {
        name: name,
        orderId: order.id,
        orderName: order.name,
        orderVehicleType: order.vehicleType,
        orderMobile: order.mobile,
        orderYear: order.date,
        packageId: packagedetail.id,
        packageSource: packagedetail.source,
        packageDestination: packagedetail.destination,
        packagePrice: packagedetail.price,
      },
    });
  }
}
