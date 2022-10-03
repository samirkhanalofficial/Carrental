import { Controller, Get } from '@nestjs/common';

@Controller('carrental')
export class CarrentalController {
  @Get()
  test() {
    return { name: 'samir' };
  }
}
