/*
 * D2iP
 * Copyright (C) SatisKia. All rights reserved.
 */

#import "_GLTriangle.h"

#import "_GLModel.h"
#import "_GLUtility.h"

@implementation _GLTriangle

- (id)initWithModel:(_GLUtility*)glu :(_GLModel*)model :(int)index
{
	self = [super init];
	if( self != nil )
	{
		int i, j;

		// 三角形の数を取得する
		_num = 0;
		[glu beginGetTriangle];
		while( [glu getTriangle:model :index :NO] )
		{
			_num++;
		}

		if( _num > 0 )
		{
			_coord_x = malloc( sizeof(float*) * _num );
			_coord_y = malloc( sizeof(float*) * _num );
			_coord_z = malloc( sizeof(float*) * _num );
			for( i = 0; i < _num; i++ )
			{
				_coord_x[i] = malloc( sizeof(float) * 3 );
				_coord_y[i] = malloc( sizeof(float) * 3 );
				_coord_z[i] = malloc( sizeof(float) * 3 );
			}
			_normal_x = malloc( sizeof(float) * _num );
			_normal_y = malloc( sizeof(float) * _num );
			_normal_z = malloc( sizeof(float) * _num );
			_center_x = malloc( sizeof(float) * _num );
			_center_y = malloc( sizeof(float) * _num );
			_center_z = malloc( sizeof(float) * _num );

			j = 0;
			[glu beginGetTriangle];
			while( [glu getTriangle:model :index :NO] )
			{
				for( i = 0; i < 3; i++ )
				{
					_coord_x[j][i] = [glu coordX:i];
					_coord_y[j][i] = [glu coordY:i];
					_coord_z[j][i] = [glu coordZ:i];
				}

				[glu getTriangleNormal:model :index :NO];
				_normal_x[j] = [glu normalX];
				_normal_y[j] = [glu normalY];
				_normal_z[j] = [glu normalZ];

				_center_x[j] = [glu centerX];
				_center_y[j] = [glu centerY];
				_center_z[j] = [glu centerZ];

				j++;
			}
		}
	}
	return self;
}

- (void)dealloc
{
	if( _num > 0 )
	{
		for( int i = 0; i < _num; i++ )
		{
			free( _coord_x[i] );
			free( _coord_y[i] );
			free( _coord_z[i] );
		}
		free( _coord_x );
		free( _coord_y );
		free( _coord_z );
		free( _normal_x );
		free( _normal_y );
		free( _normal_z );
		free( _center_x );
		free( _center_y );
		free( _center_z );
	}

#ifdef NO_OBJC_ARC
	[super dealloc];
#endif // NO_OBJC_ARC
}

- (int)num
{
	return _num;
}
- (float*)coord_x:(int)i
{
	return _coord_x[i];
}
- (float*)coord_y:(int)i
{
	return _coord_y[i];
}
- (float*)coord_z:(int)i
{
	return _coord_z[i];
}
- (float)normal_x:(int)i
{
	return _normal_x[i];
}
- (float)normal_y:(int)i
{
	return _normal_y[i];
}
- (float)normal_z:(int)i
{
	return _normal_z[i];
}
- (float)center_x:(int)i
{
	return _center_x[i];
}
- (float)center_y:(int)i
{
	return _center_y[i];
}
- (float)center_z:(int)i
{
	return _center_z[i];
}

- (BOOL)check:(int)i :(float)x_min :(float)x_max :(float)y_min :(float)y_max :(float)z_min :(float)z_max
{
	if(
		(_center_x[i] >= x_min) && (_center_x[i] <= x_max) &&
		(_center_y[i] >= y_min) && (_center_y[i] <= y_max) &&
		(_center_z[i] >= z_min) && (_center_z[i] <= z_max)
	){
		return YES;
	}
	return NO;
}

- (int)hitCheck:(_GLUtility*)glu :(float)px :(float)py :(float)pz :(float)qx :(float)qy :(float)qz :(float)r
{
	int i;
	for( i = 0; i < _num; i++ )
	{
		if(
			(_center_x[i] >= px - r) && (_center_x[i] <= px + r) &&
			(_center_y[i] >= py - r) && (_center_y[i] <= py + r) &&
			(_center_z[i] >= pz - r) && (_center_z[i] <= pz + r)
		){
			if( [glu hitCheck:px :py :pz :qx :qy :qz :_coord_x[i] :_coord_y[i] :_coord_z[i]] )
			{
				return i;
			}
		}
	}
	return -1;
}

@end
