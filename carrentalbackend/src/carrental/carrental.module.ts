import { Module } from '@nestjs/common';
import { CarrentalService } from './carrental.service';
import { CarrentalController } from './carrental.controller';
import { AdminModule } from './admin/admin.module';

@Module({
  providers: [CarrentalService],
  controllers: [CarrentalController],
  imports: [AdminModule]
})
export class CarrentalModule {}
