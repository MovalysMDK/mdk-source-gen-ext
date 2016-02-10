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

import org.dom4j.Element;

import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;

/**
 * Delegate to manage imports
 * @author lmichenaud
 *
 */
public class MF4WImportDelegate extends MW8ImportDelegate {

	/**
	 * Constructor
	 * @param p_oDelegator delegator
	 */
	public MF4WImportDelegate( Object p_oDelegator ) {
		super(p_oDelegator);
		addCategory(MF4WImportCategory.DATALOADER.name());
		addCategory(MF4WImportCategory.UI.name());
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MW8ImportDelegate#genereXml(org.dom4j.Element)
	 */
	@Override
	protected void genereXml(Element p_xParent) {
		super.genereXml(p_xParent);
		toXml( p_xParent, MF4WImportCategory.DATALOADER.name(), this.getImportsForCategory(MF4WImportCategory.DATALOADER.name()));
		toXml( p_xParent, MF4WImportCategory.UI.name(), this.getImportsForCategory(MF4WImportCategory.UI.name()));
	}
	
	/**
	 * Category of import
	 * @author lmichenaud
	 *
	 */
	public enum MF4WImportCategory {
		DATALOADER,
		UI
	}
}
