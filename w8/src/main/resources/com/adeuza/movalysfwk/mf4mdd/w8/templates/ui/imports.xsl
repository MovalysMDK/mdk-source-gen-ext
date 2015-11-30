<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
		

<!-- permet de créer une import C# à partir de n importe quel texte ou attribut -->
<xsl:template name="layout-imports">
	<xsl:text>using mdk_common;</xsl:text>
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Resources;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using Windows.UI.Popups;</xsl:text>
	<xsl:text>using Windows.UI.Xaml;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Controls;</xsl:text>
	<xsl:text>using mdk_windows8.UI;</xsl:text>
	<xsl:if test="main = 'true'">
		<xsl:if test="is-store = 'false'">
			<xsl:text>using Common.Application;</xsl:text>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template name="screen-imports">
	<xsl:text>using mdk_common;</xsl:text>
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Event;</xsl:text>
	<xsl:text>using mdk_common.Controller;</xsl:text>
	<xsl:text>using mdk_common.MFAction;</xsl:text>
	<xsl:text>using mdk_common.Resources;</xsl:text>
	<xsl:text>using mdk_windows8.UI;</xsl:text>
	<xsl:text>using mdk_common.View;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Threading.Tasks;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using Windows.UI.Popups;</xsl:text>
	<xsl:text>using Windows.UI.Xaml;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Controls;</xsl:text>
	<xsl:if test="main = 'true'">
		<xsl:if test="is-store = 'false'">
			<xsl:text>using Common.Application;</xsl:text>
		</xsl:if>
	</xsl:if>
</xsl:template>

<!-- permet de créer une import C# à partir de n importe quel texte ou attribut
<xsl:template name="panel-imports">
	<xsl:text>using mdk_common;</xsl:text>
	<xsl:text>using mdk_common.Application;</xsl:text>
	<xsl:text>using mdk_common.Event;</xsl:text>
	<xsl:text>using mdk_common.MFAction;</xsl:text>
	<xsl:text>using mdk_common.Resources;</xsl:text>
	<xsl:text>using mdk_windows8.UI;</xsl:text>
	<xsl:text>using System;</xsl:text>
	<xsl:text>using System.Collections.Generic;</xsl:text>
	<xsl:text>using System.IO;</xsl:text>
	<xsl:text>using System.Linq;</xsl:text>
	<xsl:text>using Windows.Foundation;</xsl:text>
	<xsl:text>using Windows.Foundation.Collections;</xsl:text>
	<xsl:text>using Windows.UI.Popups;</xsl:text>
	<xsl:text>using Windows.UI.Xaml;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Controls;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Controls.Primitives;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Data;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Input;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Media;</xsl:text>
	<xsl:text>using Windows.UI.Xaml.Navigation;</xsl:text>
</xsl:template>-->

</xsl:stylesheet>