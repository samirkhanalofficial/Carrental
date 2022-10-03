import { Module } from '@nestjs/common';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Admin, AdminSchema } from 'src/carrental/entities/admin.entity';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { JwtStrategy } from './jwt.strategy';
import { Package, PackageSchema } from '../entities/package.entity';
import { Order, OrderSchema } from '../entities/order.entity';
import { MailModule } from 'src/mail/mail.module';

@Module({
  imports: [
    MailModule,
    MongooseModule.forFeature([
      { name: Admin.name, schema: AdminSchema },
      { name: Package.name, schema: PackageSchema },
      { name: Order.name, schema: OrderSchema },
    ]),
    PassportModule,
    JwtModule.register({
      secret: 'process.env.ACCESS_TOKEN_SECRET',
    }),
  ],
  providers: [AdminService, JwtStrategy],
  controllers: [AdminController],
})
export class AdminModule {}
