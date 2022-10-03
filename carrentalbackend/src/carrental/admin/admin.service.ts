import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Admin, AdminDocument } from 'src/carrental/entities/admin.entity';
import * as bcrypt from 'bcrypt';
import { RegisterAdminDto } from './dto/register-admin.dto';
import { LoginAdminDto } from './dto/login-admin.dto';
import { JwtService } from '@nestjs/jwt';
import { CreatePackageDto } from './dto/create-package.dto';
import { Package, PackageDocument } from '../entities/package.entity';
import { Order, OrderDocument } from '../entities/order.entity';
import { CreateOrderDto } from './dto/create-order.dto';
import { MailService } from 'src/mail/mail.service';
@Injectable()
export class AdminService {
  constructor(
    @InjectModel(Admin.name) private adminModel: Model<AdminDocument>,
    @InjectModel(Package.name) private packageModel: Model<PackageDocument>,
    @InjectModel(Order.name) private orderModel: Model<OrderDocument>,
    private jwtService: JwtService,
    private mailService: MailService,
  ) {}

  async registerAdmin(
    registerAdminDto: RegisterAdminDto,
  ): Promise<AdminDocument> {
    const { email, password, name } = registerAdminDto;
    const salt = await bcrypt.genSalt();
    const hash = await bcrypt.hash(password, salt);
    const users = await this.adminModel.find({ email });
    if (users.length == 1) {
      throw new BadRequestException('Email already exists.');
    }
    const admin: AdminDocument = new this.adminModel({
      email,
      password: hash,
      name,
    });
    return admin.save();
  }
  async getUser(loginAdminDto: LoginAdminDto): Promise<AdminDocument> {
    const { email, password } = loginAdminDto;
    const user: AdminDocument = await this.adminModel.findOne({ email });
    if (!user) {
      throw new UnauthorizedException('Incorrect email or password');
    }
    const islogin: boolean = await bcrypt.compare(password, user.password);
    if (!islogin) {
      throw new UnauthorizedException('Incorrect email or password');
    }
    user.password = '*****';
    return user;
  }
  async getAdmins() {
    const users = await this.adminModel.find();
    const newUsers: any[] = [];
    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      user.password = '*****';
      newUsers.push(user);
    }

    return newUsers;
  }
  async deleteAdminById(id: string) {
    try {
      const admin = this.adminModel.findById(id);
      if (admin) {
        return await this.adminModel.findByIdAndRemove(id);
      } else {
        throw new BadRequestException('user not found');
      }
    } catch (err) {
      throw new BadRequestException('invalid admin id');
    }
  }
  async getToken(user: AdminDocument) {
    const { id, email, name } = user;
    const access_token = this.jwtService.sign({
      id,
      email,
      name,
    });
    return { access_token };
  }

  async createPackage(createPackageDto: CreatePackageDto) {
    const packageDocument: PackageDocument = new this.packageModel({
      ...createPackageDto,
      deleted: false,
    });
    return packageDocument.save();
  }
  async getPackagesByVehicleType(vehicleType: string) {
    const packageDocuments = this.packageModel.find({
      vehicleType,
      deleted: false,
    });
    return packageDocuments;
  }
  async deletePackagesById(id: string) {
    const packageFound = await this.getPackagesById(id);
    if (packageFound) {
      await this.packageModel.findByIdAndUpdate(id, { deleted: true });
    } else {
      throw new BadRequestException();
    }
  }
  async getPackagesById(id: string) {
    const packageFound = await this.packageModel.findById(id);
    if (!packageFound) throw new BadRequestException();
    return packageFound;
  }
  async createOrder(
    createOrderDto: CreateOrderDto,
    vehicleType: string,
  ): Promise<OrderDocument> {
    const order: OrderDocument = new this.orderModel({
      ...createOrderDto,
      vehicleType,
      isDone: false,
    });
    return order.save();
  }
  async getAllOrders(filter: string): Promise<OrderDocument[]> {
    const orders =
      filter == 'all'
        ? this.orderModel.find()
        : filter == 'pending'
        ? this.orderModel.find({ isDone: false })
        : this.orderModel.find({ isDone: true });
    return orders;
  }
  async UpdateOrders(id: string) {
    const order = await this.getOrderById(id);
    await this.orderModel.findByIdAndUpdate(id, { isDone: !order.isDone });
  }
  async getOrderById(id: string): Promise<OrderDocument> {
    const order: OrderDocument = await this.orderModel.findById(id);
    if (!order) throw new BadRequestException();
    return order;
  }
}
