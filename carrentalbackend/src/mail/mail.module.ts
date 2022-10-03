import { MailerModule } from '@nestjs-modules/mailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { Module } from '@nestjs/common';
import { MailService } from './mail.service';
import { join } from 'path';

@Module({
  imports: [
    MailerModule.forRoot({
      transport:
        'smtps://allmartcompany2078@gmail.com:kpozppxyhhikrfii@smtp.gmail.com',
      // or
      // transport: {
      //   host: 'smtp.gmail.com',
      //   secure: true,
      //   port: 465,
      //   auth: {
      //     user: 'allmartcompany2078@gmail.com',
      //     pass: 'kpozppxyhhikrfii',
      //   },
      // },
      defaults: {
        from: '"noreply@myallmart.com" <allmartcompany2078@gmail.com>',
      },
      template: {
        dir: join(__dirname, 'templates'),
        adapter: new HandlebarsAdapter(), // or new PugAdapter() or new EjsAdapter()
        options: {
          strict: false,
        },
      },
    }),
  ],
  providers: [MailService],
  exports: [MailService], // 👈 export for DI
})
export class MailModule {}
