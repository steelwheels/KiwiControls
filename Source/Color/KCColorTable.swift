/**
 * @file	KCColorTable.m
 * @brief	Define KCColorTable class
 * @par Copyright
 *   Copyright (C) 2014-2016 Steel Wheels Project
 * @par Reference
 *   <a href="http://lowlife.jp/yasusii/static/color_chart.html">RGB Color Chart</a>
 */

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

public class KCColorTable
{
	static let sharedTable = KCColorTable()

	private static func rgb(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> KCColor {
		#if os(iOS)
		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
		#else
		return NSColor(red: r, green: g, blue: b, alpha: 1.0)
		#endif
	}

	public static let snow			= rgb(1.00, 0.98, 0.98)
	public static let ghostWhite		= rgb(0.97, 0.97, 1.00)
	public static let whiteSmoke		= rgb(0.96, 0.96, 0.96)
	public static let gainsboro		= rgb(0.86, 0.86, 0.86)
	public static let floralWhite		= rgb(1.00, 0.98, 0.94)
	public static let oldLace		= rgb(0.99, 0.96, 0.90)
	public static let linen			= rgb(0.98, 0.94, 0.90)
	public static let antiqueWhite		= rgb(0.98, 0.92, 0.84)
	public static let papayaWhip		= rgb(1.00, 0.94, 0.84)
	public static let blanchedAlmond	= rgb(1.00, 0.92, 0.80)
	public static let bisque		= rgb(1.00, 0.89, 0.77)
	public static let peachPuff		= rgb(1.00, 0.85, 0.73)
	public static let navajoWhite		= rgb(1.00, 0.87, 0.68)
	public static let moccasin		= rgb(1.00, 0.89, 0.71)
	public static let cornsilk		= rgb(1.00, 0.97, 0.86)
	public static let ivory			= rgb(1.00, 1.00, 0.94)
	public static let lemonChiffon		= rgb(1.00, 0.98, 0.80)
	public static let seashell		= rgb(1.00, 0.96, 0.93)
	public static let honeydew		= rgb(0.94, 1.00, 0.94)
	public static let mintCream		= rgb(0.96, 1.00, 0.98)
	public static let azure			= rgb(0.94, 1.00, 1.00)
	public static let aliceBlue		= rgb(0.94, 0.97, 1.00)
	public static let lavender		= rgb(0.90, 0.90, 0.98)
	public static let lavenderBlush		= rgb(1.00, 0.94, 0.96)
	public static let mistyRose		= rgb(1.00, 0.89, 0.88)
	public static let white			= rgb(1.00, 1.00, 1.00)
	public static let black			= rgb(0.00, 0.00, 0.00)
	public static let darkSlateGray		= rgb(0.18, 0.31, 0.31)
	public static let dimGray		= rgb(0.41, 0.41, 0.41)
	public static let slateGray		= rgb(0.44, 0.50, 0.56)
	public static let lightSlateGray	= rgb(0.47, 0.53, 0.60)
	public static let gray			= rgb(0.75, 0.75, 0.75)
	public static let lightGray		= rgb(0.83, 0.83, 0.83)
	public static let midnightBlue		= rgb(0.10, 0.10, 0.44)
	public static let navy			= rgb(0.00, 0.00, 0.50)
	public static let navyBlue		= rgb(0.00, 0.00, 0.50)
	public static let cornflowerBlue	= rgb(0.39, 0.58, 0.93)
	public static let darkSlateBlue		= rgb(0.28, 0.24, 0.55)
	public static let slateBlue		= rgb(0.42, 0.35, 0.80)
	public static let mediumSlateBlue	= rgb(0.48, 0.41, 0.93)
	public static let lightSlateBlue	= rgb(0.52, 0.44, 1.00)
	public static let mediumBlue		= rgb(0.00, 0.00, 0.80)
	public static let royalBlue		= rgb(0.25, 0.41, 0.88)
	public static let blue			= rgb(0.00, 0.00, 1.00)
	public static let dodgerBlue		= rgb(0.12, 0.56, 1.00)
	public static let deepSkyBlue		= rgb(0.00, 0.75, 1.00)
	public static let skyBlue		= rgb(0.53, 0.81, 0.92)
	public static let lightSkyBlue		= rgb(0.53, 0.81, 0.98)
	public static let steelBlue		= rgb(0.27, 0.51, 0.71)
	public static let lightSteelBlue	= rgb(0.69, 0.77, 0.87)
	public static let lightBlue		= rgb(0.68, 0.85, 0.90)
	public static let powderBlue		= rgb(0.69, 0.88, 0.90)
	public static let paleTurquoise		= rgb(0.69, 0.93, 0.93)
	public static let darkTurquoise		= rgb(0.00, 0.81, 0.82)
	public static let mediumTurquoise	= rgb(0.28, 0.82, 0.80)
	public static let turquoise		= rgb(0.25, 0.88, 0.82)
	public static let cyan			= rgb(0.00, 1.00, 1.00)
	public static let lightCyan		= rgb(0.88, 1.00, 1.00)
	public static let cadetBlue		= rgb(0.37, 0.62, 0.63)
	public static let mediumAquamarine	= rgb(0.40, 0.80, 0.67)
	public static let aquamarine		= rgb(0.50, 1.00, 0.83)
	public static let darkGreen		= rgb(0.00, 0.39, 0.00)
	public static let darkOliveGreen	= rgb(0.33, 0.42, 0.18)
	public static let darkSeaGreen		= rgb(0.56, 0.74, 0.56)
	public static let seaGreen		= rgb(0.18, 0.55, 0.34)
	public static let mediumSeaGreen	= rgb(0.24, 0.70, 0.44)
	public static let lightSeaGreen		= rgb(0.13, 0.70, 0.67)
	public static let paleGreen		= rgb(0.60, 0.98, 0.60)
	public static let springGreen		= rgb(0.00, 1.00, 0.50)
	public static let lawnGreen		= rgb(0.49, 0.99, 0.00)
	public static let green			= rgb(0.00, 1.00, 0.00)
	public static let chartreuse		= rgb(0.50, 1.00, 0.00)
	public static let mediumSpringGreen	= rgb(0.00, 0.98, 0.60)
	public static let greenYellow		= rgb(0.68, 1.00, 0.18)
	public static let limeGreen		= rgb(0.20, 0.80, 0.20)
	public static let yellowGreen		= rgb(0.60, 0.80, 0.20)
	public static let forestGreen		= rgb(0.13, 0.55, 0.13)
	public static let oliveDrab		= rgb(0.42, 0.56, 0.14)
	public static let darkKhaki		= rgb(0.74, 0.72, 0.42)
	public static let khaki			= rgb(0.94, 0.90, 0.55)
	public static let paleGoldenrod		= rgb(0.93, 0.91, 0.67)
	public static let lightGoldenrodYellow	= rgb(0.98, 0.98, 0.82)
	public static let lightYellow		= rgb(1.00, 1.00, 0.88)
	public static let yellow		= rgb(1.00, 1.00, 0.00)
	public static let gold			= rgb(1.00, 0.84, 0.00)
	public static let lightGoldenrod	= rgb(0.93, 0.87, 0.51)
	public static let goldenrod		= rgb(0.85, 0.65, 0.13)
	public static let darkGoldenrod		= rgb(0.72, 0.53, 0.04)
	public static let rosyBrown		= rgb(0.74, 0.56, 0.56)
	public static let indianRed		= rgb(0.80, 0.36, 0.36)
	public static let saddleBrown		= rgb(0.55, 0.27, 0.07)
	public static let sienna		= rgb(0.63, 0.32, 0.18)
	public static let peru			= rgb(0.80, 0.52, 0.25)
	public static let burlywood		= rgb(0.87, 0.72, 0.53)
	public static let beige			= rgb(0.96, 0.96, 0.86)
	public static let wheat			= rgb(0.96, 0.87, 0.70)
	public static let sandyBrown		= rgb(0.96, 0.64, 0.38)
	public static let tan			= rgb(0.82, 0.71, 0.55)
	public static let chocolate		= rgb(0.82, 0.41, 0.12)
	public static let firebrick		= rgb(0.70, 0.13, 0.13)
	public static let brown			= rgb(0.65, 0.16, 0.16)
	public static let darkSalmon		= rgb(0.91, 0.59, 0.48)
	public static let salmon		= rgb(0.98, 0.50, 0.45)
	public static let lightSalmon		= rgb(1.00, 0.63, 0.48)
	public static let orange		= rgb(1.00, 0.65, 0.00)
	public static let darkOrange		= rgb(1.00, 0.55, 0.00)
	public static let coral			= rgb(1.00, 0.50, 0.31)
	public static let lightCoral		= rgb(0.94, 0.50, 0.50)
	public static let tomato		= rgb(1.00, 0.39, 0.28)
	public static let orangeRed		= rgb(1.00, 0.27, 0.00)
	public static let red			= rgb(1.00, 0.00, 0.00)
	public static let hotPink		= rgb(1.00, 0.41, 0.71)
	public static let deepPink		= rgb(1.00, 0.08, 0.58)
	public static let pink			= rgb(1.00, 0.75, 0.80)
	public static let lightPink		= rgb(1.00, 0.71, 0.76)
	public static let paleVioletRed		= rgb(0.86, 0.44, 0.58)
	public static let maroon		= rgb(0.69, 0.19, 0.38)
	public static let mediumVioletRed	= rgb(0.78, 0.08, 0.52)
	public static let violetRed		= rgb(0.82, 0.13, 0.56)
	public static let magenta		= rgb(1.00, 0.00, 1.00)
	public static let violet		= rgb(0.93, 0.51, 0.93)
	public static let plum			= rgb(0.87, 0.63, 0.87)
	public static let orchid		= rgb(0.85, 0.44, 0.84)
	public static let mediumOrchid		= rgb(0.73, 0.33, 0.83)
	public static let darkOrchid		= rgb(0.60, 0.20, 0.80)
	public static let darkViolet		= rgb(0.58, 0.00, 0.83)
	public static let blueViolet		= rgb(0.54, 0.17, 0.89)
	public static let purple		= rgb(0.63, 0.13, 0.94)
	public static let mediumPurple		= rgb(0.58, 0.44, 0.86)
	public static let thistle		= rgb(0.85, 0.75, 0.85)
	public static let snow1			= rgb(1.00, 0.98, 0.98)
	public static let snow2			= rgb(0.93, 0.91, 0.91)
	public static let snow3			= rgb(0.80, 0.79, 0.79)
	public static let snow4			= rgb(0.55, 0.54, 0.54)
	public static let seashell1		= rgb(1.00, 0.96, 0.93)
	public static let seashell2		= rgb(0.93, 0.90, 0.87)
	public static let seashell3		= rgb(0.80, 0.77, 0.75)
	public static let seashell4		= rgb(0.55, 0.53, 0.51)
	public static let antiqueWhite1		= rgb(1.00, 0.94, 0.86)
	public static let antiqueWhite2		= rgb(0.93, 0.87, 0.80)
	public static let antiqueWhite3		= rgb(0.80, 0.75, 0.69)
	public static let antiqueWhite4		= rgb(0.55, 0.51, 0.47)
	public static let bisque1		= rgb(1.00, 0.89, 0.77)
	public static let bisque2		= rgb(0.93, 0.84, 0.72)
	public static let bisque3		= rgb(0.80, 0.72, 0.62)
	public static let bisque4		= rgb(0.55, 0.49, 0.42)
	public static let peachPuff1		= rgb(1.00, 0.85, 0.73)
	public static let peachPuff2		= rgb(0.93, 0.80, 0.68)
	public static let peachPuff3		= rgb(0.80, 0.69, 0.58)
	public static let peachPuff4		= rgb(0.55, 0.47, 0.40)
	public static let navajoWhite1		= rgb(1.00, 0.87, 0.68)
	public static let navajoWhite2		= rgb(0.93, 0.81, 0.63)
	public static let navajoWhite3		= rgb(0.80, 0.70, 0.55)
	public static let navajoWhite4		= rgb(0.55, 0.47, 0.37)
	public static let lemonChiffon1		= rgb(1.00, 0.98, 0.80)
	public static let lemonChiffon2		= rgb(0.93, 0.91, 0.75)
	public static let lemonChiffon3		= rgb(0.80, 0.79, 0.65)
	public static let lemonChiffon4		= rgb(0.55, 0.54, 0.44)
	public static let cornsilk1		= rgb(1.00, 0.97, 0.86)
	public static let cornsilk2		= rgb(0.93, 0.91, 0.80)
	public static let cornsilk3		= rgb(0.80, 0.78, 0.69)
	public static let cornsilk4		= rgb(0.55, 0.53, 0.47)
	public static let ivory1		= rgb(1.00, 1.00, 0.94)
	public static let ivory2		= rgb(0.93, 0.93, 0.88)
	public static let ivory3		= rgb(0.80, 0.80, 0.76)
	public static let ivory4		= rgb(0.55, 0.55, 0.51)
	public static let honeydew1		= rgb(0.94, 1.00, 0.94)
	public static let honeydew2		= rgb(0.88, 0.93, 0.88)
	public static let honeydew3		= rgb(0.76, 0.80, 0.76)
	public static let honeydew4		= rgb(0.51, 0.55, 0.51)
	public static let lavenderBlush1	= rgb(1.00, 0.94, 0.96)
	public static let lavenderBlush2	= rgb(0.93, 0.88, 0.90)
	public static let lavenderBlush3	= rgb(0.80, 0.76, 0.77)
	public static let lavenderBlush4	= rgb(0.55, 0.51, 0.53)
	public static let mistyRose1		= rgb(1.00, 0.89, 0.88)
	public static let mistyRose2		= rgb(0.93, 0.84, 0.82)
	public static let mistyRose3		= rgb(0.80, 0.72, 0.71)
	public static let mistyRose4		= rgb(0.55, 0.49, 0.48)
	public static let azure1		= rgb(0.94, 1.00, 1.00)
	public static let azure2		= rgb(0.88, 0.93, 0.93)
	public static let azure3		= rgb(0.76, 0.80, 0.80)
	public static let azure4		= rgb(0.51, 0.55, 0.55)
	public static let slateBlue1		= rgb(0.51, 0.44, 1.00)
	public static let slateBlue2		= rgb(0.48, 0.40, 0.93)
	public static let slateBlue3		= rgb(0.41, 0.35, 0.80)
	public static let slateBlue4		= rgb(0.28, 0.24, 0.55)
	public static let royalBlue1		= rgb(0.28, 0.46, 1.00)
	public static let royalBlue2		= rgb(0.26, 0.43, 0.93)
	public static let royalBlue3		= rgb(0.23, 0.37, 0.80)
	public static let royalBlue4		= rgb(0.15, 0.25, 0.55)
	public static let blue1			= rgb(0.00, 0.00, 1.00)
	public static let blue2			= rgb(0.00, 0.00, 0.93)
	public static let blue3			= rgb(0.00, 0.00, 0.80)
	public static let blue4			= rgb(0.00, 0.00, 0.55)
	public static let dodgerBlue1		= rgb(0.12, 0.56, 1.00)
	public static let dodgerBlue2		= rgb(0.11, 0.53, 0.93)
	public static let dodgerBlue3		= rgb(0.09, 0.45, 0.80)
	public static let dodgerBlue4		= rgb(0.06, 0.31, 0.55)
	public static let steelBlue1		= rgb(0.39, 0.72, 1.00)
	public static let steelBlue2		= rgb(0.36, 0.67, 0.93)
	public static let steelBlue3		= rgb(0.31, 0.58, 0.80)
	public static let steelBlue4		= rgb(0.21, 0.39, 0.55)
	public static let deepSkyBlue1		= rgb(0.00, 0.75, 1.00)
	public static let deepSkyBlue2		= rgb(0.00, 0.70, 0.93)
	public static let deepSkyBlue3		= rgb(0.00, 0.60, 0.80)
	public static let deepSkyBlue4		= rgb(0.00, 0.41, 0.55)
	public static let skyBlue1		= rgb(0.53, 0.81, 1.00)
	public static let skyBlue2		= rgb(0.49, 0.75, 0.93)
	public static let skyBlue3		= rgb(0.42, 0.65, 0.80)
	public static let skyBlue4		= rgb(0.29, 0.44, 0.55)
	public static let lightSkyBlue1		= rgb(0.69, 0.89, 1.00)
	public static let lightSkyBlue2		= rgb(0.64, 0.83, 0.93)
	public static let lightSkyBlue3		= rgb(0.55, 0.71, 0.80)
	public static let lightSkyBlue4		= rgb(0.38, 0.48, 0.55)
	public static let slateGray1		= rgb(0.78, 0.89, 1.00)
	public static let slateGray2		= rgb(0.73, 0.83, 0.93)
	public static let slateGray3		= rgb(0.62, 0.71, 0.80)
	public static let slateGray4		= rgb(0.42, 0.48, 0.55)
	public static let lightSteelBlue1	= rgb(0.79, 0.88, 1.00)
	public static let lightSteelBlue2	= rgb(0.74, 0.82, 0.93)
	public static let lightSteelBlue3	= rgb(0.64, 0.71, 0.80)
	public static let lightSteelBlue4	= rgb(0.43, 0.48, 0.55)
	public static let lightBlue1		= rgb(0.75, 0.94, 1.00)
	public static let lightBlue2		= rgb(0.70, 0.87, 0.93)
	public static let lightBlue3		= rgb(0.60, 0.75, 0.80)
	public static let lightBlue4		= rgb(0.41, 0.51, 0.55)
	public static let lightCyan1		= rgb(0.88, 1.00, 1.00)
	public static let lightCyan2		= rgb(0.82, 0.93, 0.93)
	public static let lightCyan3		= rgb(0.71, 0.80, 0.80)
	public static let lightCyan4		= rgb(0.48, 0.55, 0.55)
	public static let paleTurquoise1	= rgb(0.73, 1.00, 1.00)
	public static let paleTurquoise2	= rgb(0.68, 0.93, 0.93)
	public static let paleTurquoise3	= rgb(0.59, 0.80, 0.80)
	public static let paleTurquoise4	= rgb(0.40, 0.55, 0.55)
	public static let cadetBlue1		= rgb(0.60, 0.96, 1.00)
	public static let cadetBlue2		= rgb(0.56, 0.90, 0.93)
	public static let cadetBlue3		= rgb(0.48, 0.77, 0.80)
	public static let cadetBlue4		= rgb(0.33, 0.53, 0.55)
	public static let turquoise1		= rgb(0.00, 0.96, 1.00)
	public static let turquoise2		= rgb(0.00, 0.90, 0.93)
	public static let turquoise3		= rgb(0.00, 0.77, 0.80)
	public static let turquoise4		= rgb(0.00, 0.53, 0.55)
	public static let cyan1			= rgb(0.00, 1.00, 1.00)
	public static let cyan2			= rgb(0.00, 0.93, 0.93)
	public static let cyan3			= rgb(0.00, 0.80, 0.80)
	public static let cyan4			= rgb(0.00, 0.55, 0.55)
	public static let darkSlateGray1	= rgb(0.59, 1.00, 1.00)
	public static let darkSlateGray2	= rgb(0.55, 0.93, 0.93)
	public static let darkSlateGray3	= rgb(0.47, 0.80, 0.80)
	public static let darkSlateGray4	= rgb(0.32, 0.55, 0.55)
	public static let aquamarine1		= rgb(0.50, 1.00, 0.83)
	public static let aquamarine2		= rgb(0.46, 0.93, 0.78)
	public static let aquamarine3		= rgb(0.40, 0.80, 0.67)
	public static let aquamarine4		= rgb(0.27, 0.55, 0.45)
	public static let darkSeaGreen1		= rgb(0.76, 1.00, 0.76)
	public static let darkSeaGreen2		= rgb(0.71, 0.93, 0.71)
	public static let darkSeaGreen3		= rgb(0.61, 0.80, 0.61)
	public static let darkSeaGreen4		= rgb(0.41, 0.55, 0.41)
	public static let seaGreen1		= rgb(0.33, 1.00, 0.62)
	public static let seaGreen2		= rgb(0.31, 0.93, 0.58)
	public static let seaGreen3		= rgb(0.26, 0.80, 0.50)
	public static let seaGreen4		= rgb(0.18, 0.55, 0.34)
	public static let paleGreen1		= rgb(0.60, 1.00, 0.60)
	public static let paleGreen2		= rgb(0.56, 0.93, 0.56)
	public static let paleGreen3		= rgb(0.49, 0.80, 0.49)
	public static let paleGreen4		= rgb(0.33, 0.55, 0.33)
	public static let springGreen1		= rgb(0.00, 1.00, 0.50)
	public static let springGreen2		= rgb(0.00, 0.93, 0.46)
	public static let springGreen3		= rgb(0.00, 0.80, 0.40)
	public static let springGreen4		= rgb(0.00, 0.55, 0.27)
	public static let green1		= rgb(0.00, 1.00, 0.00)
	public static let green2		= rgb(0.00, 0.93, 0.00)
	public static let green3		= rgb(0.00, 0.80, 0.00)
	public static let green4		= rgb(0.00, 0.55, 0.00)
	public static let chartreuse1		= rgb(0.50, 1.00, 0.00)
	public static let chartreuse2		= rgb(0.46, 0.93, 0.00)
	public static let chartreuse3		= rgb(0.40, 0.80, 0.00)
	public static let chartreuse4		= rgb(0.27, 0.55, 0.00)
	public static let oliveDrab1		= rgb(0.75, 1.00, 0.24)
	public static let oliveDrab2		= rgb(0.70, 0.93, 0.23)
	public static let oliveDrab3		= rgb(0.60, 0.80, 0.20)
	public static let oliveDrab4		= rgb(0.41, 0.55, 0.13)
	public static let darkOliveGreen1	= rgb(0.79, 1.00, 0.44)
	public static let darkOliveGreen2	= rgb(0.74, 0.93, 0.41)
	public static let darkOliveGreen3	= rgb(0.64, 0.80, 0.35)
	public static let darkOliveGreen4	= rgb(0.43, 0.55, 0.24)
	public static let khaki1		= rgb(1.00, 0.96, 0.56)
	public static let khaki2		= rgb(0.93, 0.90, 0.52)
	public static let khaki3		= rgb(0.80, 0.78, 0.45)
	public static let khaki4		= rgb(0.55, 0.53, 0.31)
	public static let lightGoldenrod1	= rgb(1.00, 0.93, 0.55)
	public static let lightGoldenrod2	= rgb(0.93, 0.86, 0.51)
	public static let lightGoldenrod3	= rgb(0.80, 0.75, 0.44)
	public static let lightGoldenrod4	= rgb(0.55, 0.51, 0.30)
	public static let lightYellow1		= rgb(1.00, 1.00, 0.88)
	public static let lightYellow2		= rgb(0.93, 0.93, 0.82)
	public static let lightYellow3		= rgb(0.80, 0.80, 0.71)
	public static let lightYellow4		= rgb(0.55, 0.55, 0.48)
	public static let yellow1		= rgb(1.00, 1.00, 0.00)
	public static let yellow2		= rgb(0.93, 0.93, 0.00)
	public static let yellow3		= rgb(0.80, 0.80, 0.00)
	public static let yellow4		= rgb(0.55, 0.55, 0.00)
	public static let gold1			= rgb(1.00, 0.84, 0.00)
	public static let gold2			= rgb(0.93, 0.79, 0.00)
	public static let gold3			= rgb(0.80, 0.68, 0.00)
	public static let gold4			= rgb(0.55, 0.46, 0.00)
	public static let goldenrod1		= rgb(1.00, 0.76, 0.15)
	public static let goldenrod2		= rgb(0.93, 0.71, 0.13)
	public static let goldenrod3		= rgb(0.80, 0.61, 0.11)
	public static let goldenrod4		= rgb(0.55, 0.41, 0.08)
	public static let darkGoldenrod1	= rgb(1.00, 0.73, 0.06)
	public static let darkGoldenrod2	= rgb(0.93, 0.68, 0.05)
	public static let darkGoldenrod3	= rgb(0.80, 0.58, 0.05)
	public static let darkGoldenrod4	= rgb(0.55, 0.40, 0.03)
	public static let rosyBrown1		= rgb(1.00, 0.76, 0.76)
	public static let rosyBrown2		= rgb(0.93, 0.71, 0.71)
	public static let rosyBrown3		= rgb(0.80, 0.61, 0.61)
	public static let rosyBrown4		= rgb(0.55, 0.41, 0.41)
	public static let indianRed1		= rgb(1.00, 0.42, 0.42)
	public static let indianRed2		= rgb(0.93, 0.39, 0.39)
	public static let indianRed3		= rgb(0.80, 0.33, 0.33)
	public static let indianRed4		= rgb(0.55, 0.23, 0.23)
	public static let sienna1		= rgb(1.00, 0.51, 0.28)
	public static let sienna2		= rgb(0.93, 0.47, 0.26)
	public static let sienna3		= rgb(0.80, 0.41, 0.22)
	public static let sienna4		= rgb(0.55, 0.28, 0.15)
	public static let burlywood1		= rgb(1.00, 0.83, 0.61)
	public static let burlywood2		= rgb(0.93, 0.77, 0.57)
	public static let burlywood3		= rgb(0.80, 0.67, 0.49)
	public static let burlywood4		= rgb(0.55, 0.45, 0.33)
	public static let wheat1		= rgb(1.00, 0.91, 0.73)
	public static let wheat2		= rgb(0.93, 0.85, 0.68)
	public static let wheat3		= rgb(0.80, 0.73, 0.59)
	public static let wheat4		= rgb(0.55, 0.49, 0.40)
	public static let tan1			= rgb(1.00, 0.65, 0.31)
	public static let tan2			= rgb(0.93, 0.60, 0.29)
	public static let tan3			= rgb(0.80, 0.52, 0.25)
	public static let tan4			= rgb(0.55, 0.35, 0.17)
	public static let chocolate1		= rgb(1.00, 0.50, 0.14)
	public static let chocolate2		= rgb(0.93, 0.46, 0.13)
	public static let chocolate3		= rgb(0.80, 0.40, 0.11)
	public static let chocolate4		= rgb(0.55, 0.27, 0.07)
	public static let firebrick1		= rgb(1.00, 0.19, 0.19)
	public static let firebrick2		= rgb(0.93, 0.17, 0.17)
	public static let firebrick3		= rgb(0.80, 0.15, 0.15)
	public static let firebrick4		= rgb(0.55, 0.10, 0.10)
	public static let brown1		= rgb(1.00, 0.25, 0.25)
	public static let brown2		= rgb(0.93, 0.23, 0.23)
	public static let brown3		= rgb(0.80, 0.20, 0.20)
	public static let brown4		= rgb(0.55, 0.14, 0.14)
	public static let salmon1		= rgb(1.00, 0.55, 0.41)
	public static let salmon2		= rgb(0.93, 0.51, 0.38)
	public static let salmon3		= rgb(0.80, 0.44, 0.33)
	public static let salmon4		= rgb(0.55, 0.30, 0.22)
	public static let lightSalmon1		= rgb(1.00, 0.63, 0.48)
	public static let lightSalmon2		= rgb(0.93, 0.58, 0.45)
	public static let lightSalmon3		= rgb(0.80, 0.51, 0.38)
	public static let lightSalmon4		= rgb(0.55, 0.34, 0.26)
	public static let orange1		= rgb(1.00, 0.65, 0.00)
	public static let orange2		= rgb(0.93, 0.60, 0.00)
	public static let orange3		= rgb(0.80, 0.52, 0.00)
	public static let orange4		= rgb(0.55, 0.35, 0.00)
	public static let darkOrange1		= rgb(1.00, 0.50, 0.00)
	public static let darkOrange2		= rgb(0.93, 0.46, 0.00)
	public static let darkOrange3		= rgb(0.80, 0.40, 0.00)
	public static let darkOrange4		= rgb(0.55, 0.27, 0.00)
	public static let coral1		= rgb(1.00, 0.45, 0.34)
	public static let coral2		= rgb(0.93, 0.42, 0.31)
	public static let coral3		= rgb(0.80, 0.36, 0.27)
	public static let coral4		= rgb(0.55, 0.24, 0.18)
	public static let tomato1		= rgb(1.00, 0.39, 0.28)
	public static let tomato2		= rgb(0.93, 0.36, 0.26)
	public static let tomato3		= rgb(0.80, 0.31, 0.22)
	public static let tomato4		= rgb(0.55, 0.21, 0.15)
	public static let orangeRed1		= rgb(1.00, 0.27, 0.00)
	public static let orangeRed2		= rgb(0.93, 0.25, 0.00)
	public static let orangeRed3		= rgb(0.80, 0.22, 0.00)
	public static let orangeRed4		= rgb(0.55, 0.15, 0.00)
	public static let red1			= rgb(1.00, 0.00, 0.00)
	public static let red2			= rgb(0.93, 0.00, 0.00)
	public static let red3			= rgb(0.80, 0.00, 0.00)
	public static let red4			= rgb(0.55, 0.00, 0.00)
	public static let deepPink1		= rgb(1.00, 0.08, 0.58)
	public static let deepPink2		= rgb(0.93, 0.07, 0.54)
	public static let deepPink3		= rgb(0.80, 0.06, 0.46)
	public static let deepPink4		= rgb(0.55, 0.04, 0.31)
	public static let hotPink1		= rgb(1.00, 0.43, 0.71)
	public static let hotPink2		= rgb(0.93, 0.42, 0.65)
	public static let hotPink3		= rgb(0.80, 0.38, 0.56)
	public static let hotPink4		= rgb(0.55, 0.23, 0.38)
	public static let pink1			= rgb(1.00, 0.71, 0.77)
	public static let pink2			= rgb(0.93, 0.66, 0.72)
	public static let pink3			= rgb(0.80, 0.57, 0.62)
	public static let pink4			= rgb(0.55, 0.39, 0.42)
	public static let lightPink1		= rgb(1.00, 0.68, 0.73)
	public static let lightPink2		= rgb(0.93, 0.64, 0.68)
	public static let lightPink3		= rgb(0.80, 0.55, 0.58)
	public static let lightPink4		= rgb(0.55, 0.37, 0.40)
	public static let paleVioletRed1	= rgb(1.00, 0.51, 0.67)
	public static let paleVioletRed2	= rgb(0.93, 0.47, 0.62)
	public static let paleVioletRed3	= rgb(0.80, 0.41, 0.54)
	public static let paleVioletRed4	= rgb(0.55, 0.28, 0.36)
	public static let maroon1		= rgb(1.00, 0.20, 0.70)
	public static let maroon2		= rgb(0.93, 0.19, 0.65)
	public static let maroon3		= rgb(0.80, 0.16, 0.56)
	public static let maroon4		= rgb(0.55, 0.11, 0.38)
	public static let violetRed1		= rgb(1.00, 0.24, 0.59)
	public static let violetRed2		= rgb(0.93, 0.23, 0.55)
	public static let violetRed3		= rgb(0.80, 0.20, 0.47)
	public static let violetRed4		= rgb(0.55, 0.13, 0.32)
	public static let magenta1		= rgb(1.00, 0.00, 1.00)
	public static let magenta2		= rgb(0.93, 0.00, 0.93)
	public static let magenta3		= rgb(0.80, 0.00, 0.80)
	public static let magenta4		= rgb(0.55, 0.00, 0.55)
	public static let orchid1		= rgb(1.00, 0.51, 0.98)
	public static let orchid2		= rgb(0.93, 0.48, 0.91)
	public static let orchid3		= rgb(0.80, 0.41, 0.79)
	public static let orchid4		= rgb(0.55, 0.28, 0.54)
	public static let plum1			= rgb(1.00, 0.73, 1.00)
	public static let plum2			= rgb(0.93, 0.68, 0.93)
	public static let plum3			= rgb(0.80, 0.59, 0.80)
	public static let plum4			= rgb(0.55, 0.40, 0.55)
	public static let mediumOrchid1		= rgb(0.88, 0.40, 1.00)
	public static let mediumOrchid2		= rgb(0.82, 0.37, 0.93)
	public static let mediumOrchid3		= rgb(0.71, 0.32, 0.80)
	public static let mediumOrchid4		= rgb(0.48, 0.22, 0.55)
	public static let darkOrchid1		= rgb(0.75, 0.24, 1.00)
	public static let darkOrchid2		= rgb(0.70, 0.23, 0.93)
	public static let darkOrchid3		= rgb(0.60, 0.20, 0.80)
	public static let darkOrchid4		= rgb(0.41, 0.13, 0.55)
	public static let purple1		= rgb(0.61, 0.19, 1.00)
	public static let purple2		= rgb(0.57, 0.17, 0.93)
	public static let purple3		= rgb(0.49, 0.15, 0.80)
	public static let purple4		= rgb(0.33, 0.10, 0.55)
	public static let mediumPurple1		= rgb(0.67, 0.51, 1.00)
	public static let mediumPurple2		= rgb(0.62, 0.47, 0.93)
	public static let mediumPurple3		= rgb(0.54, 0.41, 0.80)
	public static let mediumPurple4		= rgb(0.36, 0.28, 0.55)
	public static let thistle1		= rgb(1.00, 0.88, 1.00)
	public static let thistle2		= rgb(0.93, 0.82, 0.93)
	public static let thistle3		= rgb(0.80, 0.71, 0.80)
	public static let thistle4		= rgb(0.55, 0.48, 0.55)
	public static let gray0			= rgb(0.00, 0.00, 0.00)
	public static let gray1			= rgb(0.01, 0.01, 0.01)
	public static let gray2			= rgb(0.02, 0.02, 0.02)
	public static let gray3			= rgb(0.03, 0.03, 0.03)
	public static let gray4			= rgb(0.04, 0.04, 0.04)
	public static let gray5			= rgb(0.05, 0.05, 0.05)
	public static let gray6			= rgb(0.06, 0.06, 0.06)
	public static let gray7			= rgb(0.07, 0.07, 0.07)
	public static let gray8			= rgb(0.08, 0.08, 0.08)
	public static let gray9			= rgb(0.09, 0.09, 0.09)
	public static let gray10		= rgb(0.10, 0.10, 0.10)
	public static let gray11		= rgb(0.11, 0.11, 0.11)
	public static let gray12		= rgb(0.12, 0.12, 0.12)
	public static let gray13		= rgb(0.13, 0.13, 0.13)
	public static let gray14		= rgb(0.14, 0.14, 0.14)
	public static let gray15		= rgb(0.15, 0.15, 0.15)
	public static let gray16		= rgb(0.16, 0.16, 0.16)
	public static let gray17		= rgb(0.17, 0.17, 0.17)
	public static let gray18		= rgb(0.18, 0.18, 0.18)
	public static let gray19		= rgb(0.19, 0.19, 0.19)
	public static let gray20		= rgb(0.20, 0.20, 0.20)
	public static let gray21		= rgb(0.21, 0.21, 0.21)
	public static let gray22		= rgb(0.22, 0.22, 0.22)
	public static let gray23		= rgb(0.23, 0.23, 0.23)
	public static let gray24		= rgb(0.24, 0.24, 0.24)
	public static let gray25		= rgb(0.25, 0.25, 0.25)
	public static let gray26		= rgb(0.26, 0.26, 0.26)
	public static let gray27		= rgb(0.27, 0.27, 0.27)
	public static let gray28		= rgb(0.28, 0.28, 0.28)
	public static let gray29		= rgb(0.29, 0.29, 0.29)
	public static let gray30		= rgb(0.30, 0.30, 0.30)
	public static let gray31		= rgb(0.31, 0.31, 0.31)
	public static let gray32		= rgb(0.32, 0.32, 0.32)
	public static let gray33		= rgb(0.33, 0.33, 0.33)
	public static let gray34		= rgb(0.34, 0.34, 0.34)
	public static let gray35		= rgb(0.35, 0.35, 0.35)
	public static let gray36		= rgb(0.36, 0.36, 0.36)
	public static let gray37		= rgb(0.37, 0.37, 0.37)
	public static let gray38		= rgb(0.38, 0.38, 0.38)
	public static let gray39		= rgb(0.39, 0.39, 0.39)
	public static let gray40		= rgb(0.40, 0.40, 0.40)
	public static let gray41		= rgb(0.41, 0.41, 0.41)
	public static let gray42		= rgb(0.42, 0.42, 0.42)
	public static let gray43		= rgb(0.43, 0.43, 0.43)
	public static let gray44		= rgb(0.44, 0.44, 0.44)
	public static let gray45		= rgb(0.45, 0.45, 0.45)
	public static let gray46		= rgb(0.46, 0.46, 0.46)
	public static let gray47		= rgb(0.47, 0.47, 0.47)
	public static let gray48		= rgb(0.48, 0.48, 0.48)
	public static let gray49		= rgb(0.49, 0.49, 0.49)
	public static let gray50		= rgb(0.50, 0.50, 0.50)
	public static let gray51		= rgb(0.51, 0.51, 0.51)
	public static let gray52		= rgb(0.52, 0.52, 0.52)
	public static let gray53		= rgb(0.53, 0.53, 0.53)
	public static let gray54		= rgb(0.54, 0.54, 0.54)
	public static let gray55		= rgb(0.55, 0.55, 0.55)
	public static let gray56		= rgb(0.56, 0.56, 0.56)
	public static let gray57		= rgb(0.57, 0.57, 0.57)
	public static let gray58		= rgb(0.58, 0.58, 0.58)
	public static let gray59		= rgb(0.59, 0.59, 0.59)
	public static let gray60		= rgb(0.60, 0.60, 0.60)
	public static let gray61		= rgb(0.61, 0.61, 0.61)
	public static let gray62		= rgb(0.62, 0.62, 0.62)
	public static let gray63		= rgb(0.63, 0.63, 0.63)
	public static let gray64		= rgb(0.64, 0.64, 0.64)
	public static let gray65		= rgb(0.65, 0.65, 0.65)
	public static let gray66		= rgb(0.66, 0.66, 0.66)
	public static let gray67		= rgb(0.67, 0.67, 0.67)
	public static let gray68		= rgb(0.68, 0.68, 0.68)
	public static let gray69		= rgb(0.69, 0.69, 0.69)
	public static let gray70		= rgb(0.70, 0.70, 0.70)
	public static let gray71		= rgb(0.71, 0.71, 0.71)
	public static let gray72		= rgb(0.72, 0.72, 0.72)
	public static let gray73		= rgb(0.73, 0.73, 0.73)
	public static let gray74		= rgb(0.74, 0.74, 0.74)
	public static let gray75		= rgb(0.75, 0.75, 0.75)
	public static let gray76		= rgb(0.76, 0.76, 0.76)
	public static let gray77		= rgb(0.77, 0.77, 0.77)
	public static let gray78		= rgb(0.78, 0.78, 0.78)
	public static let gray79		= rgb(0.79, 0.79, 0.79)
	public static let gray80		= rgb(0.80, 0.80, 0.80)
	public static let gray81		= rgb(0.81, 0.81, 0.81)
	public static let gray82		= rgb(0.82, 0.82, 0.82)
	public static let gray83		= rgb(0.83, 0.83, 0.83)
	public static let gray84		= rgb(0.84, 0.84, 0.84)
	public static let gray85		= rgb(0.85, 0.85, 0.85)
	public static let gray86		= rgb(0.86, 0.86, 0.86)
	public static let gray87		= rgb(0.87, 0.87, 0.87)
	public static let gray88		= rgb(0.88, 0.88, 0.88)
	public static let gray89		= rgb(0.89, 0.89, 0.89)
	public static let gray90		= rgb(0.90, 0.90, 0.90)
	public static let gray91		= rgb(0.91, 0.91, 0.91)
	public static let gray92		= rgb(0.92, 0.92, 0.92)
	public static let gray93		= rgb(0.93, 0.93, 0.93)
	public static let gray94		= rgb(0.94, 0.94, 0.94)
	public static let gray95		= rgb(0.95, 0.95, 0.95)
	public static let gray96		= rgb(0.96, 0.96, 0.96)
	public static let gray97		= rgb(0.97, 0.97, 0.97)
	public static let gray98		= rgb(0.98, 0.98, 0.98)
	public static let gray99		= rgb(0.99, 0.99, 0.99)
	public static let gray100		= rgb(1.00, 1.00, 1.00)
	public static let darkGray		= rgb(0.66, 0.66, 0.66)
	public static let darkBlue		= rgb(0.00, 0.00, 0.55)
	public static let darkCyan		= rgb(0.00, 0.55, 0.55)
	public static let darkMagenta		= rgb(0.55, 0.00, 0.55)
	public static let darkRed		= rgb(0.55, 0.00, 0.00)
	public static let lightGreen		= rgb(0.56, 0.93, 0.56)

	public init(){

	}
}
