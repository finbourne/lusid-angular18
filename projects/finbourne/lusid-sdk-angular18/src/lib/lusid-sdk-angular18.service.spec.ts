import { TestBed } from '@angular/core/testing';

import { LusidSdkAngular18Service } from './lusid-sdk-angular18.service';

describe('LusidSdkAngular18Service', () => {
  let service: LusidSdkAngular18Service;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LusidSdkAngular18Service);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
