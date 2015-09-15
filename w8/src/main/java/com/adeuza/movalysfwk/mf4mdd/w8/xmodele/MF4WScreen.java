/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.xmodele;

import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MScreen;
import org.dom4j.Element;

/**
 *
 */
public class MF4WScreen extends MScreen {
	/**
	 * Constructor, boilerplate for super class constructor
	 *
	 * @param p_sUmlName uml name
	 * @param p_sName    name
	 * @param p_oPackage screen package
	 */
	protected MF4WScreen(String p_sUmlName, String p_sName, MPackage p_oPackage) {
		super(p_sUmlName, p_sName, p_oPackage);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);

		// Insert the screen layout inside the xml description only when there is no Page,
		if (this.getLayout() != null) {
			p_xElement.add(this.getLayout().toXml());
		}
	}
}
