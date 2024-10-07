import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LusidSdkAngular18Component } from './lusid-sdk-angular18.component';

describe('LusidSdkAngular18Component', () => {
  let component: LusidSdkAngular18Component;
  let fixture: ComponentFixture<LusidSdkAngular18Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LusidSdkAngular18Component]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LusidSdkAngular18Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
