import {
  Controller,
  Post,
  Param,
  Patch,
  Body,
  Get,
  Delete,
  UsePipes,
  ValidationPipe,
  Request,
  UseGuards,
  InternalServerErrorException,
  BadRequestException,
} from '@nestjs/common';
import { MailService } from 'src/mail/mail.service';
import { AdminDocument } from '../entities/admin.entity';
import { AdminService } from './admin.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { CreatePackageDto } from './dto/create-package.dto';
import { LoginAdminDto } from './dto/login-admin.dto';
import { RegisterAdminDto } from './dto/register-admin.dto';
import { JwtAuthGuard } from './jwt-auth.guard';

@Controller('carrental/admin')
export class AdminController {
  constructor(
    private adminService: AdminService,
    private mailService: MailService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @UsePipes(ValidationPipe)
  @Post('/register')
  registerAdmin(@Body() registerAdminDto: RegisterAdminDto) {
    return this.adminService.registerAdmin(registerAdminDto);
  }

  @UsePipes(ValidationPipe)
  @Post('/login')
  async loginAdmin(@Body() loginAdminDto: LoginAdminDto) {
    const user: AdminDocument = await this.adminService.getUser(loginAdminDto);
    const token = this.adminService.getToken(user);
    return token;
  }
  @UsePipes(ValidationPipe)
  @UseGuards(JwtAuthGuard)
  @Get('/me')
  async getMe(@Request() req) {
    if (!req.user) throw new InternalServerErrorException();
    return req.user;
  }
  @UsePipes(ValidationPipe)
  @UseGuards(JwtAuthGuard)
  @Get('/admins')
  async getAdmins(@Request() req) {
    if (!req.user) throw new InternalServerErrorException();
    return this.adminService.getAdmins();
  }
  @UsePipes(ValidationPipe)
  @UseGuards(JwtAuthGuard)
  @Delete('/deleteAdmin/:id')
  async deleteAdminById(@Request() req, @Param('id') id: string) {
    if (!req.user) throw new InternalServerErrorException();
    return this.adminService.deleteAdminById(id);
  }

  @UsePipes(ValidationPipe)
  @UseGuards(JwtAuthGuard)
  @Post('/createPackage')
  async authorize(@Request() req, @Body() createPackageDto: CreatePackageDto) {
    if (!req.user) throw new InternalServerErrorException();
    return this.adminService.createPackage(createPackageDto);
  }

  @Get('/getAllPackages/:vehicleType')
  async getPackagesByVehicleType(@Param('vehicleType') vehicleType: string) {
    return this.adminService.getPackagesByVehicleType(vehicleType);
  }
  @Get('/getPackage/:id')
  async getPackagesById(@Param('id') id: string) {
    return this.adminService.getPackagesById(id);
  }

  @UseGuards(JwtAuthGuard)
  @Delete('/deletePackage/:id')
  async deletePackagesById(@Param('id') id: string) {
    return this.adminService.deletePackagesById(id);
  }

  //order

  @UsePipes(ValidationPipe)
  @Post('/createOrder')
  async createOrder(@Body() createOrderDto: CreateOrderDto) {
    const packageFound = await this.adminService.getPackagesById(
      createOrderDto.packageId,
    );
    if (!packageFound) {
      throw new BadRequestException();
    }
    const order = await this.adminService.createOrder(
      createOrderDto,
      packageFound.vehicleType,
    );
    if (order) {
      const admins = await this.adminService.getAdmins();
      admins.forEach(async (admin) => {
        await this.mailService.sendOrdermail(
          admin.email,
          admin.name,
          order,
          packageFound,
        );
      });
    }

    return {
      order,
      package: packageFound,
    };
  }
  @UseGuards(JwtAuthGuard)
  @Patch('/updateOrder/:id')
  async updateOrder(@Param('id') id: string) {
    await this.adminService.UpdateOrders(id);
    return this.adminService.getOrderById(id);
  }
  @UseGuards(JwtAuthGuard)
  @Get('/getAllOrders/:filter')
  async getAllOrders(@Param('filter') filter: string) {
    const orders = await this.adminService.getAllOrders(filter);
    const neworders: any[] = [];
    for (let i = 0; i < orders.length; i++) {
      console.log(orders[i].packageId);
      try {
        const packageFound = await this.adminService.getPackagesById(
          orders[i].packageId,
        );
        neworders.push({ order: orders[i], packagee: packageFound });
      } catch (err) {
        neworders.push({
          order: orders[i],
          packagee: {
            _id: '',
            source: '',
            destination: '',
            vehicleType: '',
            price: 0,
            createdAt: '000000',
            updatedAt: '000000',
            __v: 0,
          },
        });
      }
    }
    return neworders;
  }
  @UseGuards(JwtAuthGuard)
  @Get('/getOrder/:id')
  async getOrdersById(@Param('id') id: string) {
    const order = await this.adminService.getOrderById(id);
    const packageFound = await this.adminService.getPackagesById(
      order.packageId,
    );
    return {
      order,
      package: packageFound,
    };
  }
}
