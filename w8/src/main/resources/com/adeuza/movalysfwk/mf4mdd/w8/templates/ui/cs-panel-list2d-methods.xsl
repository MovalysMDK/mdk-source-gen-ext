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

<xsl:template name="add-interface-imfcomponentdictionary">
	<xsl:text>, IMFComponentDictionary</xsl:text>
</xsl:template>

<xsl:template name="add-list2d-methods">
	<xsl:text>&#13;#region MFList2D Methods&#13;</xsl:text><xsl:text></xsl:text>
	<xsl:text disable-output-escaping="yes"><![CDATA[
	    /*private delegate void FWKEvent(object sender, SelectionChangedEventArgs e, object elementParent);
        private FWKEvent selectedItem = new FWKEvent(MFMethods.MFSelectedItemClick);

        private delegate void FWKRoutedEvent(object sender, RoutedEventArgs e, object elementParent);
        private FWKRoutedEvent addedItem = new FWKRoutedEvent(MFMethods.MFAddItemClick);
        private FWKRoutedEvent deletedItem = new FWKRoutedEvent(MFMethods.MFDeleteItemClick);

        public void MFList2D_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            selectedItem(sender, e, this);
        }

        public void MFList2D_AddClickOverride(object sender, RoutedEventArgs e)
        {
            addedItem(sender, e, this);
        }

        public void MFList2D_DeleteClickOverride(object sender, RoutedEventArgs e)
        {
            deletedItem(sender, e, this);
        }

        private Dictionary<string, object> _componentDictionary = new Dictionary<string, object>(MFConstantes.Capacities.DICTIONARY_MEDIUM_CAPACITY);
        public Dictionary<string, object> ComponentDictionary
        {
            get
            {
                return _componentDictionary;
            }
            set
            {
                _componentDictionary = value;
            }
        }*/
		]]></xsl:text>
	<xsl:text>&#13;#endregion&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>