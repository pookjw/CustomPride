#import <Metal/Metal.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <substrate.h>

double __unlockProgress = 0.;

namespace cp_MTLRenderPassColorAttachmentDescriptorInternal {
    namespace setClearColor {
        void (*original)(MTLRenderPassColorAttachmentDescriptor *, SEL, MTLClearColor);
        void custom(MTLRenderPassColorAttachmentDescriptor *self, SEL _cmd, MTLClearColor clearColor) {
            MTLClearColor customClearColor = MTLClearColorMake(0., __unlockProgress, __unlockProgress, 1.);
            return original(self, _cmd, customClearColor);
        }
    }
}

namespace cp_DrawingController {
    namespace renderer_didInitializeWithEnvironment {
        void (*original)(id, SEL, id, id);
        void custom(id /* _TtC20PridePosterExtension17DrawingController */ self, SEL _cmd, id /* PRRenderer */ renderer, id /* PRPosterEnvironmentImpl */ envrionment) {
            __unlockProgress = ((double (*)(id, SEL))objc_msgSend)(envrionment, sel_registerName("unlockProgress"));
            original(self, _cmd, renderer, envrionment);
        }
    }

    namespace renderer_didUpdateEnvironment_withTransition {
        void (*original)(id, SEL, id, id, id);
        void custom(id /* _TtC20PridePosterExtension17DrawingController */ self, SEL _cmd, id /* PRRenderer */ renderer, id /* PRPosterEnvironmentImpl */ envrionment, id /* PRPosterTransition */ transition) {
            __unlockProgress = ((double (*)(id, SEL))objc_msgSend)(envrionment, sel_registerName("unlockProgress"));
            original(self, _cmd, renderer, envrionment, transition);
        }
    }
}

__attribute__((constructor)) void init() {
    MSHookMessageEx(objc_lookUpClass("MTLRenderPassColorAttachmentDescriptorInternal"), sel_registerName("setClearColor:"), (IMP)&cp_MTLRenderPassColorAttachmentDescriptorInternal::setClearColor::custom, (IMP *)&cp_MTLRenderPassColorAttachmentDescriptorInternal::setClearColor::original);
    MSHookMessageEx(objc_lookUpClass("_TtC20PridePosterExtension17DrawingController"), sel_registerName("renderer:didInitializeWithEnvironment:"), (IMP)&cp_DrawingController::renderer_didInitializeWithEnvironment::custom, (IMP *)&cp_DrawingController::renderer_didInitializeWithEnvironment::original);
    MSHookMessageEx(objc_lookUpClass("_TtC20PridePosterExtension17DrawingController"), sel_registerName("renderer:didUpdateEnvironment:withTransition:"), (IMP)&cp_DrawingController::renderer_didUpdateEnvironment_withTransition::custom, (IMP *)&cp_DrawingController::renderer_didUpdateEnvironment_withTransition::original);
}