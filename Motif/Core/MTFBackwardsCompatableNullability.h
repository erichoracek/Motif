//
//  MTFBackwardsCompatableNullability.h
//  Motif
//
//  Created by Eric Horacek on 3/15/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

// Xcode 6.3 defines new language features to declare nullability
#if __has_feature(nullability)
#define MTF_NS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#define MTF_NS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#define mtf_nullable nullable
#define mtf_nonnull nonnull
#define mtf_null_unspecified null_unspecified
#define mtf_null_resettable null_resettable
#define __mtf_nullable __nullable
#define __mtf_nonnull __nonnull
#define __mtf_null_unspecified __null_unspecified
#else
#define MTF_NS_ASSUME_NONNULL_BEGIN
#define MTF_NS_ASSUME_NONNULL_END
#define mtf_nullable
#define mtf_nonnull
#define mtf_null_unspecified
#define mtf_null_resettable
#define __mtf_nullable
#define __mtf_nonnull
#define __mtf_null_unspecified
#endif
